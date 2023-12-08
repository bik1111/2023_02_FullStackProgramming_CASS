// ProfileWidget.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileWidget extends StatelessWidget {
  final String username;

  // Add a constructor that accepts the 'username' parameter
  ProfileWidget({required this.username});

  @override
  Widget build(BuildContext context) {
    // Here you can display the user's profile information
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey, // Set a background color for the CircleAvatar
            child: SvgPicture.asset(
              'assets/jpg/profile.jpg',
              height: 100, // Adjust the height as needed
              width: 100, // Adjust the width as needed
            ),
          ),
          SizedBox(height: 8),
          Text(
            username, // Use the 'username' parameter here
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
