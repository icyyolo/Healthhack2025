from flask import Blueprint, request, jsonify

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=['POST'])
def login():
    # Get JSON data
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    # Validate credentials (dummy example)
    if username == 'admin' and password == '123':
        return jsonify({"message": "Login successful!"}), 200
    else:
        return jsonify({"error": "Invalid credentials"}), 401