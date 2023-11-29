// create_post_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YourWritePostScreen extends StatefulWidget {
  final int communityId;

  YourWritePostScreen({required this.communityId});

  @override
  _YourWritePostScreenState createState() => _YourWritePostScreenState();
}

class _YourWritePostScreenState extends State<YourWritePostScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 쓰기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: '내용을 입력하세요.',
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String postTitle = _titleController.text;
                  String postContent = _contentController.text;

                  _sendPostRequest(postTitle, postContent, widget.communityId);

                  Navigator.pop(context);
                },
                child: Text('완료'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendPostRequest(String title, String content, int communityId) async {
    final apiUrl = 'http://localhost:3000/api/create/post/$communityId';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'title': title,
        'content': content,
      },
    );

    if (response.statusCode == 200) {
      print('Post created successfully');
    } else {
      print('Error creating post. Status code: ${response.statusCode}');
    }
  }
}
