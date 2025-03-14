import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary // User's message color (primary color)
              : theme.colorScheme.secondary, // Other user's message color (secondary color)
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser
                ? theme.colorScheme.onPrimary // Text color for user's message
                : theme.colorScheme.onSecondary, // Text color for other user's message
          ),
        ),
      ),
    );
  }
}