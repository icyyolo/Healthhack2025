import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'chat_page.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isConnected = false;
  late Timer _timer;

  void _test() async {
    bool status = await _apiService.pingServer();
    setState(() {
      _isConnected = status;
    });
  }

  void _login() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both username and password")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Simulate a login request (replace with actual API call)
    // await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    bool status = await _apiService.validateLogin(username, password);
    setState(() {
      _isLoading = false;
    });
    if (status) {
      // Navigate to the chat page after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatPage(username: username)),
      );
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the async method here
    // Start polling by calling fetchData every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _test();
    });

    // Initial data fetch
    _test();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    print("Timer canceled");
    super.dispose();
  }

  // Handle 'Enter' key press
  void _onSubmit(String value) {
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF23A5C3), // Background color of the entire page
      backgroundColor: Colors.grey, // Background color of the entire page
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400, // Fixed width for the box
            height: 600, // Fixed height for the box
            padding: EdgeInsets.all(20), // Padding inside the box
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the box
              borderRadius: BorderRadius.circular(20), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                ClipOval(
                  child: Image.asset(
                    "images/Logo.png", // Replace with your image path
                    width: 100, // Adjust the width as needed
                    height: 100, // Adjust the height as needed
                    
                  ),
                ),
                SizedBox(height: 20),
                // Welcome to ManarDr text
                Text(
                  "Welcome to Dr Discharge",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black, // Text color
                  ),
                ),
                SizedBox(height: 20),
                // Username field
                Container(
                  height: 60, // Fixed height for the text field
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      filled: true,
                      fillColor: Colors.white, // Background color of the text field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onSubmitted: _onSubmit, // Handle 'Enter' key press
                  ),
                ),
                SizedBox(height: 16),
                // Password field
                Container(
                  height: 60, // Fixed height for the text field
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.white, // Background color of the text field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    onSubmitted: _onSubmit, // Handle 'Enter' key press
                  ),
                ),
                SizedBox(height: 24),
                // Login button
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.blue, // Button color
                        ),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                SizedBox(height: 16),
                // White line divider above "Log in with Singpass" text
                Divider(
                  color: Colors.grey, // Divider color
                  thickness: 1, // Line thickness
                ),
                SizedBox(height: 16),
                // Log in with Singpass text
                _isLoading
                    ? CircularProgressIndicator() // Show loading spinner here
                    : Text(
                        "Log in with Singpass",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black, // Text color
                        ),
                      ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
