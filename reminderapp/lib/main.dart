import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/chat_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Set the login page as the home screen
      routes: {
        '/login': (context) => LoginPage(), // Route for the login page
        '/chat': (context) {
          final username = ModalRoute.of(context)!.settings.arguments as String;
          return ChatPage(username: username);
        },
        '/settings': (context) {
          final username = ModalRoute.of(context)!.settings.arguments as String;
          return SettingsPage(username: username);
        },
      },
    );
  }
}
