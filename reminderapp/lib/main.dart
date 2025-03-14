import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/chat_page.dart';
import 'pages/settings_page.dart';
import 'pages/transcript_page.dart';
import 'theme_provider.dart'; // Import the ThemeProvider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Create an instance of ThemeProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: ThemeData.light().copyWith(
        // Customize light theme
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurple, // Primary color for light mode
          onPrimary: Colors.white, // Text color on primary color
          surface: Colors.white, // Background color
          onSurface: Colors.black, // Text color on background
          secondary: Colors.grey,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black), // Default text color for light mode
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // Customize dark theme
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple, // Primary color for dark mode
          onPrimary: Colors.white, // Text color on primary color
          surface: Color(0xFF121212), // Background color
          onSurface: Colors.white, // Text color on background
          secondary: Color(0xFF3A3B3C),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              color: Colors.white), // Default text color for dark mode
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode:
          themeProvider.themeMode, // Use the theme mode from ThemeProvider
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
        '/transcript': (context) {
          final username = ModalRoute.of(context)!.settings.arguments as String;
          return TranscriptPage(
              username:
                  username); // Fixed: Use TranscriptPage instead of SettingsPage
        },
      },
    );
  }
}
