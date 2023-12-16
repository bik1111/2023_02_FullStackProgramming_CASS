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

  Future<http.Response> _register(String username, String password) async {
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
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(username: username),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
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
            builder: (context) => Theme(
              data: ThemeData(
                // 추가: 원하는 배경 색상 설정
                scaffoldBackgroundColor: Colors.white,
              ),
              child: HomePage(username: username),
            ),
          ),
        ).then((_) {
          Navigator.removeRouteBelow(context, ModalRoute.of(context)!);
        });
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



  Future<void> _showRegistrationDialog() async {
    String username = '';
    String password = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Register'),
          content: Column(
            children: [
              // Username input
              TextField(
                onChanged: (value) => username = value,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16.0),

              // Password input
              TextField(
                onChanged: (value) => password = value,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                print("Register button pressed");
                await _register(username, password);
                print("Registration completed");
                Navigator.pop(context); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Register'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CASS - 카공족을 위한 카페 리뷰 및 커뮤니티 웹 서비스'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/jpg/background_image.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16.0),

                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(), // 텍스트 필드에 외곽선 추가
                    ),
                    ),
                SizedBox(height: 16.0),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 24.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showRegistrationDialog(),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Register'),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        print("Login button pressed");
                        await _login();
                        print("Login completed");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
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
