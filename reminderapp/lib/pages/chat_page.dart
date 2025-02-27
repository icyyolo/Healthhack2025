import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart';
import '../services/api_service.dart';

class ChatPage extends StatefulWidget {
  final String username;

  ChatPage({required this.username});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // TODO, change the chunks to lower
      // List<String> chunks = _splitMessage(message, 10);
      // for (String chunk in chunks) {
      //   String serverReply = await _apiService.sendChunkToServer(chunk);
      //   setState(() {
      //     messages.add({"user": chunk, "server": serverReply});
      //   });
      // }

      String serverReply = await _apiService.sendChunkToServer(message);
      setState(() {
        messages.add({"user": message, "server": serverReply});
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Welcome, ${widget.username}"),
        title: const Text("ManarDr"),
        backgroundColor:
            Colors.blue, //ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu)),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome back!\n${widget.username ?? "Guest"}',
                // 'Welcome back!\n ',
                // title: Text("Welcome, ${widget.username}"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Handle navigation
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Handle navigation
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                int reversedIndex = messages.length - 1 - index;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MessageBubble(
                      text: messages[reversedIndex]["user"] ?? "",
                      isUser: true,
                    ),
                    MessageBubble(
                      text: messages[reversedIndex]["server"] ?? "",
                      isUser: false,
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
