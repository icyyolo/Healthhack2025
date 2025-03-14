import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/medication.dart';
import '../models/suggestions.dart';

class ApiService {
  final String serverUrl = "http://127.0.0.1:5000";
  final String renderServerUri =
      "https://renderhealthhack2025.onrender.com"; // Change this to "http://127.0.0.1:5000" for testing purposes
  // final String renderServerUri = "http://127.0.0.1:5000";

  Future<List<Suggestion>> getSuggestions(String username) async {
    final response = await http.post(
      Uri.parse(serverUrl + "/api/suggestions"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username}),
    );

    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson
          .map((suggestionMap) => Suggestion(
                title: suggestionMap['title'],
                description: suggestionMap['description'],
              ))
          .toList();
    } else {
      throw Exception("Failed to load suggestions");
    }
  }

  Future<List<Medication>> getMedication(String user) async {
    List<Medication> medications = [];
    try {
      var response = await http.post(
        Uri.parse(serverUrl + "/api/medicine"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": user}),
      );
      List<dynamic> decodedJson = jsonDecode(response.body);
      List<Medication> medications = decodedJson
          .map((medicationMap) => Medication.fromMap(medicationMap))
          .toList();
      return medications;
    } catch (e) {
      return medications;
    }
  }

  Future<String> checkServerOnline() async {
    try {
      var response = await http.get(
        Uri.parse(renderServerUri + "/api/checkalive"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return renderServerUri;
      }
      return serverUrl;
    } catch (e) {
      return serverUrl;
    }
  }

  Future<String> sendChunkToServer(String chunk) async {
    try {
      var response = await http.post(
        Uri.parse(serverUrl + "/send"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": chunk}),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["reply"] ?? "No reply";
      } else {
        return "Error from server: ${response.body}";
      }
    } catch (e) {
      return "Error sending message: $e";
    }
  }

  Future<bool> validateLogin(String username, String password) async {
    try {
      var uri = await checkServerOnline();
      var response = await http.post(
        Uri.parse(uri + "/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> pingServer() async {
    try {
      var response = await http.get(Uri.parse(serverUrl + "/testing"),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data["test"] == true) {
          return true;
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
