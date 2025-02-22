import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final String serverUrl = "http://127.0.0.1:5000/send";
  bool _isLoading = false;

  void sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      List<String> chunks = _splitMessage(message, 10);
      for (String chunk in chunks) {
        String serverReply = await _sendChunkToServer(chunk);
        setState(() {
          messages.add({"user": chunk, "server": serverReply});
        });
      }

      _controller.clear();
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _splitMessage(String message, int chunkSize) {
    List<String> chunks = [];
    for (int i = 0; i < message.length; i += chunkSize) {
      chunks.add(message.substring(
          i, i + chunkSize > message.length ? message.length : i + chunkSize));
    }
    return chunks;
  }

  Future<String> _sendChunkToServer(String chunk) async {
    try {
      var response = await http.post(
        Uri.parse(serverUrl),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Page"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse:
                  true, // Reverse the list to show the latest message at the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                int reversedIndex = messages.length - 1 - index;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          messages[reversedIndex]["user"] ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          messages[reversedIndex]["server"] ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: _isLoading
                      ? CircularProgressIndicator(color: Colors.blue)
                      : Icon(Icons.send, color: Colors.blue),
                  onPressed: _isLoading ? null : sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
