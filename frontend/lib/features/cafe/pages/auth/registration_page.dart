import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:full_stack_project/features/cafe/pages/home_page.dart';

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

    if (username.isEmpty || password.isEmpty) {
      return http.Response('Validation failed', 400);
    }

    Map<String, dynamic> registrationData = {
      'username': username,
      'password': password,
    };

    try {
      RegisterNewUser registerNewUser = RegisterNewUser('localhost:3000/api/user/register');
      final response = await registerNewUser.postHttpResponse(registrationData);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(username: username),
          ),
        );
      } else {
        print('Registration failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }

    return http.Response('An unexpected error occurred', 500);
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      print('Validation failed. Username or password is empty.');
      return;
    }

    Map<String, dynamic> loginData = {
      'username': username,
      'password': password,
    };

    try {
      LoginAPi loginApi = LoginAPi('localhost:3000/api/user/login');
      final response = await loginApi.postHttpResponse(loginData);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['ok'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(username: username),
            ),
          );
        } else {
          print('Login failed. Message: ${responseData['msg']}');
        }
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('카공족을 위한 웹 커뮤니티 서비스, CASS'),
    ),
    body: Stack(
      fit: StackFit.expand, // Make the stack fill the entire space
      children: [
        // Background image
        Image.asset(
          'assets/jpg/background_image.jpg', // Replace with the path to your image asset
          fit: BoxFit.cover, // Cover the entire screen
        ),
                Container(
          color: Colors.black.withOpacity(0.2), // Adjust opacity as needed
        ),
        Padding(
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
                      _register();
                      print("Registration completed");
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Set the button color to green
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Register'),
                  ),

                  // Login button
                  ElevatedButton(
                    onPressed: () async {
                      print("Login button pressed");
                      _login();
                      print("Login completed");
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Set the button color to green
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}