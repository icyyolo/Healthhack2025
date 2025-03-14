import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/message_bubble.dart';
import '../services/api_service.dart';
import 'settings_page.dart';
import 'transcript_page.dart';

class ChatPage extends StatefulWidget {
  final String username;

  ChatPage({required this.username});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String imageAssetPath;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.imageAssetPath,
  });
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  List<Medication> medications = [
    Medication(
      name: 'Aspirin',
      dosage: '100mg',
      frequency: 'Every 6 hours',
      imageAssetPath: 'images/Aspirin.png',
    ),
    Medication(
      name: 'Nitroglycerin',
      dosage: '0.4mg',
      frequency: 'Every 8 hours',
      imageAssetPath: 'images/Nitroglycerin.png',
    ),
  ];

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

      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  void showMedicationImage(BuildContext context, String imageAssetPath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageAssetPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("images/Logo.png"),
            ),
            SizedBox(width: 8),
            const Text(
              "Dr Discharge",
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey,
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
                        SizedBox(height: 5),
                        Text(
                          widget.username,
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
                    title: const Text('View Transcript',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            // color: Colors.black,
                            fontWeight: FontWeight.w300)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TranscriptPage(username: widget.username),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Medications',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        // color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Display medications in a stacked format
                  ...medications.map((medication) {
                    return GestureDetector(
                      onTap: () {
                        showMedicationImage(context, medication.imageAssetPath);
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Next Dose:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '3pm', // Replace with actual next dose time if available
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  // color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset(
                                    medication.imageAssetPath,
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        medication.name,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          // color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${medication.dosage} • ${medication.frequency}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: const Text('Settings',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      // color: Colors.black,
                      fontWeight: FontWeight.w300)),
              onTap: () {
                Navigator.pop(context);
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
                color: theme.colorScheme.surface, // Theme-aware background
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey,
                width: 1.0,
                ),
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
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6), // Theme-aware hint text color
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface, // Theme-aware text color
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        sendMessage();
                      },
                    ),
                  ),
                  IconButton(
                    icon: _isLoading
                        ? CircularProgressIndicator(color: theme.colorScheme.primary) // Theme-aware loading indicator
                        : Icon(Icons.send, color: theme.colorScheme.primary), // Theme-aware icon color
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