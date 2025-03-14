from flask import Blueprint, request, jsonify
from backend.routes.mongodb import find_many_collections

medicine_bp = Blueprint('medicine', __name__)

@medicine_bp.route('/api/medicine', methods=['POST'])
def medicine():
    data = request.json
    username = data.get('username')
    temp = find_many_collections({"username": username}, "medicine")
    print(temp)
    return jsonify(temp), 200
    pass