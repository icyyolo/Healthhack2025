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
    
# TODO Transfer this to another folder
@medicine_bp.route('/api/suggestions', methods=['POST'])
def suggestions():
    return jsonify({
    "title": "Take Medication on Time",
    "description": "Ensure you take your medication at the prescribed times to avoid missing doses.",
  },
  {
    "title": "Stay Hydrated",
    "description": "Drink plenty of water throughout the day to stay healthy.",
  },
  {
    "title": "Consult Your Doctor",
    "description": "If you experience any side effects, consult your doctor immediately.",
  }), 200