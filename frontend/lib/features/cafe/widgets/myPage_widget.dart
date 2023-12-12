import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/pages/auth/registration_page.dart';
import 'package:full_stack_project/features/cafe/pages/home_page.dart';

class MyPage extends StatelessWidget {
  final String username;
  final TextEditingController usernameController; // Add the TextEditingController parameter

  const MyPage({Key? key, required this.username, required this.usernameController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        color: Colors.black.withOpacity(0.3),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to My Page, $username!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement "회원정보 변경" functionality
                _navigateToMemberInfoChange(context);
              },
              child: Text('회원정보 변경'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement "로그아웃" functionality
                _performLogout(context);
              },
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMemberInfoChange(BuildContext context) {
    // Implement navigation to the member information change page
    // Replace MemberInfoChangePage with your actual page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberInfoChangePage(username: username),
      ),
    );
  }

  void _performLogout(BuildContext context) {
    // Implement logout functionality
    // You may want to clear user session, navigate to the login page, etc.
    // For simplicity, this example just pops the current page.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage()
      ),
    );
  }
}

// Placeholder for the MemberInfoChangePage
class MemberInfoChangePage extends StatelessWidget {
  final String username;

  const MemberInfoChangePage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원정보 변경'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Change member information for $username',
              style: TextStyle(fontSize: 18),
            ),
            // Add form fields or other widgets for changing member information
          ],
        ),
      ),
    );
  }
}
