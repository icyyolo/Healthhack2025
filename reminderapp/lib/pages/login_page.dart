import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'chat_page.dart';

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
    _test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to ManarDr"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text("Login"),
                  ),
            Text(
              _isConnected ? "Connected!" : "Not Connected.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
