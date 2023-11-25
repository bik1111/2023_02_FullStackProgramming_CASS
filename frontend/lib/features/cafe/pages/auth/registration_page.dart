import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile picture selection
            GestureDetector(
              onTap: () async {
                final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _image = image;
                });
              },
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: _image != null
                    ? FileImage(File(_image!.path)) as ImageProvider<Object>?
                    : AssetImage('assets/profile_picture.jpg'),
              ),
            ),
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

            // Registration button
            ElevatedButton(
              onPressed: () {
                // Access input values
                String username = _usernameController.text;
                String password = _passwordController.text;

                // Access profile picture path, use a default if null
                String profilePicturePath = _image?.path ?? 'assets/default_profile_picture.jpg';

                // Handle registration logic using username, password, and profilePicturePath
                // For example, you can print the values for demonstration
                print('Username: $username, Password: $password, Profile Picture: $profilePicturePath');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
