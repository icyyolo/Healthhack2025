import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
  List<Map<String, String>> messages = []; // Store user message + server reply
  final TextEditingController _controller = TextEditingController();
  final String serverUrl =
      "http://127.0.0.1:5000/send"; // Change if using a remote server

  void sendMessage() async {
    String message = _controller.text;
    if (message.isNotEmpty) {
      List<String> chunks =
          _splitMessage(message, 10); // Splitting into chunks of 10 characters

      for (String chunk in chunks) {
        String serverReply = await _sendChunkToServer(chunk);
        setState(() {
          messages.add({"user": chunk, "server": serverReply});
        });
      }

      _controller.clear();
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
        return data["reply"] ?? "No reply"; // Get server response
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
      appBar: AppBar(title: Text("Chat Page")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(messages[index]["user"] ?? ""),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(messages[index]["server"] ?? ""),
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
                    decoration: InputDecoration(hintText: "Type a message..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
