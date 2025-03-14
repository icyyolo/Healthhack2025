from flask import Blueprint, request, jsonify
from backend.routes.mongodb import find_one_collection
import hashlib

auth_bp = Blueprint('auth', __name__)

def checkPassword(password, salt, hashed):
    string = password + salt
    print(string)
    temp = hashlib.sha256(string.encode('utf-8')).hexdigest()
    return (temp == hashed)

@auth_bp.route('/login', methods=['POST'])
def login():
    # Get JSON data
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    temp = find_one_collection({"username": username}, "users")

    print(temp)
    if (temp == None):
        return jsonify({"error": "Invalid credentials"}), 401
    

    # Validate credentials (dummy example)
    if checkPassword(password, temp["salt"], temp["password"]):
        return jsonify({"message": "Login successful!"}), 200
    else:
        return jsonify({"error": "Invalid credentials"}), 401