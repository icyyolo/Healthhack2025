from flask import Flask, request, jsonify

app = Flask(__name__)

received_messages = {}

@app.route('/testing', methods=['GET'])
def getTesting():
    print("ok")
    return jsonify({"test": "true"})

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
    response_message = f"Server received: {message_chunk[::-1]}"  # Reverse text as an example
    return jsonify({"status": "Chunk received", "reply": response_message}), 200

@app.route('/get_message', methods=['GET'])
def get_full_message():
    session_id = request.remote_addr
    full_message = "".join(received_messages.get(session_id, []))
    return jsonify({"full_message": full_message})

@app.route('/login', methods=['POST'])
def login():
    # Get JSON data
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    # Validate credentials (dummy example)
    if username == "admin" and password == "abc":
        return jsonify({"message": "Login successful!"}), 200
    else:
        return jsonify({"error": "Invalid credentials"}), 401

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)