from pymongo import MongoClient
import os
from dotenv import load_dotenv

# Returns a client
def init_pymongo():
    global dbname
    load_dotenv()
    uri = os.getenv("PYMONGO_API_KEY")
    dbname = os.getenv("DB_NAME")
    client = MongoClient(uri)
    # db = client["healthhack2025"]
    # collection1 = db["users"]
    # document = {"name": "testing", "data": "idk"}
    # result = collection1.find_one(document)
    return client

def close_client(client):
    client.close()

# Returns Collection
def open_collection(name, client):
    db = client[dbname]
    collection = db[name]
    return collection

def find_one_collection(query, colname):
    client = init_pymongo()
    col = open_collection(colname, client)
    obj = col.find_one(query)
    close_client(client)
    return obj

