import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/message_bubble.dart';
import '../services/api_service.dart';
import 'settings_page.dart';

class ChatPage extends StatefulWidget {
  final String username;

  ChatPage({required this.username});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Declare FocusNode
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      String serverReply = await _apiService.sendChunkToServer(message);
      setState(() {
        messages.add({"user": message, "server": serverReply});
      });
      _controller.clear();
      setState(() {
        _isLoading = false;
      });

      // Automatically focus the text field again after sending the message
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey, // Updated color
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu, color: Colors.black), // White icon
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20, // Adjust the size of the image
              backgroundImage: AssetImage("images/Logo.png"), // Your image asset
            ),
            SizedBox(width: 8), // Space between the image and the text
            const Text(
              "Dr Discharge",
              style: TextStyle(
                fontFamily: 'Inter', 
                color: Colors.black, 
                fontWeight: FontWeight.w500
              ), // You can change the text color here
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey, // Background color of the header
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5), // Add some spacing between the texts
                  Text(
                    widget.username, // Display the username
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Home',
                style: TextStyle(fontFamily: 'Inter',
                color: Colors.black,
                fontWeight: FontWeight.w300)
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Settings',
              style: TextStyle(fontFamily: 'Inter',
                color: Colors.black,
                fontWeight: FontWeight.w300)
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(username: widget.username),
                  ),
                );
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode, // Set focus node
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none, // Remove default border
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      textInputAction: TextInputAction.send, // Set Enter key to "send"
                      onSubmitted: (value) {
                        sendMessage(); // Call sendMessage() when Enter is pressed
                      },
                    ),
                  ),
                  IconButton(
                    icon: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Icon(Icons.send, color: Colors.blue),
                    onPressed: _isLoading ? null : sendMessage,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}