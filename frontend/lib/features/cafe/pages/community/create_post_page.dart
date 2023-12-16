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
        title: Text('게시글 작성하기'),
        backgroundColor: Colors.green,
        // 추가: 뒤로가기 아이콘 추가
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '글 제목',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            // 변경: 입력 필드 스타일 개선
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: '제목을 입력하세요',
                // 추가: 입력 필드에 그림자 효과
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '내용',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            // 변경: 입력 필드 스타일 개선
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: '내용을 입력하세요',
                // 추가: 입력 필드에 그림자 효과
                filled: true,
                fillColor: Colors.grey[200],
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  // 변경: 버튼 스타일 조정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    '확인',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
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
