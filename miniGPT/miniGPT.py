import os
from dotenv import load_dotenv

from langchain.chat_models import init_chat_model
from langchain_ollama import OllamaEmbeddings
from langchain_chroma import Chroma
import json

from langchain_core.tools import tool
from langchain_core.messages import SystemMessage
from langgraph.prebuilt import ToolNode
from langgraph.checkpoint.memory import MemorySaver
from langgraph.graph import MessagesState
from langgraph.prebuilt import ToolNode
from langgraph.prebuilt import create_react_agent

def initllm():
    global llm, memory, agent_executor, vector_store
    load_dotenv()
    USER_AGENT = 'myagent'
    LANGSMITH_TRACING = "true"
    GROQ_API_KEY = os.getenv("GROQ_API_KEY")
    LANGSMITH_API_KEY = os.getenv("LANGSMITH_API_KEY")

    llm = init_chat_model("llama3-8b-8192", model_provider="groq")

    # Initialize Chroma vector_store
    persist_directory = "chromadb"
    embeddings = OllamaEmbeddings(model="llama3")
    vector_store = Chroma(persist_directory=persist_directory, embedding_function=embeddings)

    print("Restoring ChromaDB (Will take around 1.5 mins)...")
    # Load the backup JSON
    with open("miniGPT/json/chroma_backup.json", "r") as f:
        backup_data = json.load(f)

    # Add data back into the vectorstore
    vector_store.add_texts(
        texts=backup_data["documents"],
        metadatas=backup_data.get("metadatas", []),
        ids=backup_data["ids"]
    )

    memory = MemorySaver()
    agent_executor = create_react_agent(llm, [retrieve], checkpointer=memory)

    print("ChromaDB is restored from 'chroma_backup.json'")

@tool(response_format="content_and_artifact")
def retrieve(query: str):
    """Retrieve information related to a query."""
    retrieved_docs = vector_store.similarity_search(query, k=3)
    serialized = "\n\n".join(
        (f"Source: {doc.metadata}\n" f"Content: {doc.page_content}")
        for doc in retrieved_docs
    )
    return serialized, retrieved_docs

# Step 1: Generate an AIMessage that may include a tool-call to be sent.
async def query_or_respond(state: MessagesState):
    """Generate tool call for retrieval or respond."""
    llm_with_tools = llm.bind_tools([retrieve])
    response = await llm_with_tools.ainvoke(state["messages"])
    # MessagesState appends messages to state instead of overwriting
    return {"messages": [response]}

# Step 2: Execute the retrieval.
tools = ToolNode([retrieve])

# Step 3: Generate a response using the retrieved content.
def generate(state: MessagesState):
    """Generate answer with the retrieved context."""
    # Get generated ToolMessages
    recent_tool_messages = []
    for message in reversed(state["messages"]):
        if message.type == "tool":
            recent_tool_messages.append(message)
        else:
            break
    tool_messages = recent_tool_messages[::-1]

    # Format into prompt
    docs_content = "\n\n".join(doc.content for doc in tool_messages)
    system_message_content = (
        "You are an AI assistant designed to either summarise a doctor's report or help post-discharge patients answer questions"
        
        "Do not mention anything about tool calls in the response"
        "Assist patients with their symptom descriptions and appointment requests."
        "Patients may provide descriptions of their new symptoms and request for an analysis of their condition based on these symptoms."
        "After a patient has described their symptoms, you should recommend the most appropriate department for the patient's condition."
        "Once the department has been recommended, ask the patient if they would like assistance in scheduling an appointment with the recommended department."
        "Be prepared to provide continued assistance."
        "The retrieved information is useful when responding especially if the question is about dietary advice."
        "If the tool call yields irrelevant information, generate a response independently without mentioning about the tool call."
        "If you cannot answer properly, prompt for more information."
        "Elaborate as much as possible."
        
        "\n\n"
        f"{docs_content}"
    )
    conversation_messages = [
        message for message in state["messages"]
        if message.type in ("human", "system") or (message.type == "ai" and not message.tool_calls)
    ]
    prompt = [SystemMessage(system_message_content)] + conversation_messages

    # Run
    response = llm.ainvoke(prompt)
    return {"messages": [response]}

async def askLLM(id, input):
    input_message = (input)
    config = {"configurable": {"thread_id": id}}

    async for output in agent_executor.astream(
        {"messages": [{"role": "user", "content": input_message}]},
        stream_mode="updates",
        config=config,
    ):
        pass
    return output["agent"]["messages"][0].content.split("</tool-use>")[-1].strip()

initllm()