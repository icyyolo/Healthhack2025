import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/message_bubble.dart';
import '../services/api_service.dart';
import '../models/medication.dart'; // Import the Medication class
import 'drawer.dart'; // Import the custom drawer

class ChatPage extends StatefulWidget {
  final String username;

  ChatPage({required this.username});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<Medication> medications = [];
  // List<Medication> medications = [
  //   Medication(
  //     name: 'Aspirin',
  //     dosage: '100mg',
  //     frequency: 'Every 6 hours',
  //     imageAssetPath: 'images/Aspirin.png',
  //   ),
  //   Medication(
  //     name: 'Nitroglycerin',
  //     dosage: '0.4mg',
  //     frequency: 'Every 8 hours',
  //     imageAssetPath: 'images/Nitroglycerin.png',
  //   ),
  //   Medication(
  //     name: 'Aspirins',
  //     dosage: '1000mg',
  //     frequency: 'Every 6 hours',
  //     imageAssetPath: 'images/Aspirin.png',
  //   ),
  //   Medication(
  //     name: 'Aspirinss',
  //     dosage: '1001mg',
  //     frequency: 'Every 6 hours',
  //     imageAssetPath: 'images/Aspirin.png',
  //   ),
  // ];

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

  void getMedication() async {
    try {
      // Call the API service to get medications
      List<Medication> fetchedMedications =
          await _apiService.getMedication(widget.username);

      // Update the state with the fetched medications
      setState(() {
        medications = fetchedMedications;
      });
    } catch (e) {
      // Handle errors (e.g., show a snackbar or log the error)
      print("Error fetching medications: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getMedication();
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
      drawer: CustomDrawer(
        username: widget.username,
        medications: medications,
        showMedicationImage: (imageAssetPath) {
          showMedicationImage(context, imageAssetPath);
        },
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
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.grey,
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
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        sendMessage();
                      },
                    ),
                  ),
                  IconButton(
                    icon: _isLoading
                        ? CircularProgressIndicator(
                            color: theme.colorScheme.primary)
                        : Icon(Icons.send, color: theme.colorScheme.primary),
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
