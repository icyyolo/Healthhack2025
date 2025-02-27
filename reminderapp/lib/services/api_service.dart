import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String serverUrl = "http://127.0.0.1:5000";

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
      var response = await http.post(
        Uri.parse(serverUrl + "/login"),
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
