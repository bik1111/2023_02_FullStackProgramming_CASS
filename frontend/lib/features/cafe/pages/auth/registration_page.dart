import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:full_stack_project/provider/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:full_stack_project/features/cafe/pages/home_page.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<http.Response> _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Check if username, password, and image are not empty
    if (username.isEmpty || password.isEmpty) {
      // Handle validation or show an error message
      return http.Response('Validation failed', 400);
    }

    Map<String, dynamic> registrationData = {
      'username': username,
      'password': password,
    };

    print('Registration data: $registrationData');

    try {
      RegisterNewUser registerNewUser = RegisterNewUser('localhost:3000/api/user/register');
      final response = await registerNewUser.postHttpResponse(registrationData);

      if (response.statusCode == 200) {
        print('Server response: ${response.statusCode} ${response.body}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // Change to your actual home page
          ),
        );
      } else {
        // Registration failed, handle the error (e.g., show an error message)
        print('Registration failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle errors during the HTTP request
      print('Error during HTTP request: $e');
      // Handle or show an error message as needed
    }

    // Add a return statement at the end
    return http.Response('An unexpected error occurred', 500);
  }

  Future<void> _login() async {
   String username = _usernameController.text;
  String password = _passwordController.text;

  // Check if username and password are not empty
  if (username.isEmpty || password.isEmpty) {
    // Handle validation or show an error message
    throw http.Response('Validation failed', 400);
  }

  Map<String, dynamic> loginData = {
    'username': username,
    'password': password,
  };

  print('Login data: $loginData');

  try {
    LoginAPi loginApi = LoginAPi('localhost:3000/api/user/login');
    final response = await loginApi.postHttpResponse(loginData);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Server response: ${response.statusCode} ${response.body}');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setToken(responseData['data']); // Access data using []

      if (responseData['ok'] == true) {
        // Login successful, navigate to home page
        print('Server response: ${response.statusCode} ${response.body}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // Change to your actual home page
          ),
        );
      } else {
        // Login failed, show an error message or handle it accordingly
        print('Login failed. Message: ${responseData['msg']}');
      }
    } else {
      // Login failed, handle the error (e.g., show an error message)
      print('Login failed. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Handle errors during the HTTP request
    print('Error during HTTP request: $e');
    // Handle or show an error message as needed
    throw e; // Add a throw statement to handle the error
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('당신을 위한 CASS'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile picture selection
          SizedBox(height: 16.0),

          // Username input
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          SizedBox(height: 16.0),

          // Password input
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 24.0),

          // Buttons in a row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Registration button
              ElevatedButton(
                onPressed: () async {
                  print("Register button pressed");
                  await _register();
                  print("Registration completed");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set the button color to green
                  foregroundColor: Colors.white
                ),
                child: const Text('Register'),
              ),

              // Login button
              ElevatedButton(
                onPressed: () async {
                  print("Login button pressed");
                  await _login();
                  print("Login completed");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set the button color to green
                  foregroundColor: Colors.white
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}

void main() {
  runApp(MaterialApp(
    home: RegistrationPage(),
  ));
}
