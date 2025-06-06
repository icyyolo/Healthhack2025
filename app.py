# from miniGPT import miniGPT
from flask import Flask, request, jsonify
from backend.routes.auth import auth_bp
from backend.routes.medicine import medicine_bp

app = Flask(__name__)
app.register_blueprint(auth_bp)
app.register_blueprint(medicine_bp)

received_messages = {}

@app.route('/send', methods=['POST'])
async def receive_chunk():
    data = request.json
    message_chunk = data.get("message", "")

    if not message_chunk:
        return jsonify({"error": "No message received"}), 400

    # Store chunks based on session ID (for demonstration)
    session_id = request.remote_addr  # Use IP as a simple session ID
    if session_id not in received_messages:
        received_messages[session_id] = []
    
    received_messages[session_id].append(message_chunk)

    print(f"Received chunk: {message_chunk}")

    # Example: Server sends a modified message back
    # response_message = f"Server received: {message_chunk[::-1]}"  # Reverse text as an example
    
    # rmb uncomment this
    # response_message = await miniGPT.askLLM("1", message_chunk)
    response_message = "hi"
    return jsonify({"status": "Chunk received", "reply": response_message}), 200

@app.route('/get_message', methods=['GET'])
def get_full_message():
    session_id = request.remote_addr
    full_message = "".join(received_messages.get(session_id, []))
    return jsonify({"full_message": full_message})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
