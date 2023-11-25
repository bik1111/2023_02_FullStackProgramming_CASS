import 'package:flutter/material.dart';


class ProfileWidget extends StatelessWidget {
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
            // Here you can display the user's profile image
          ),
          SizedBox(height: 8),
          Text(
            '카페왕김카페', // Here you can display the user's name
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'bik1111@naver.com', // Here you can display the user's email
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
