import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModifyPostPage extends StatefulWidget {
  final int postId;
  final Map<String, dynamic> postDetails;

  ModifyPostPage({required this.postId, required this.postDetails});

  @override
  _ModifyPostPageState createState() => _ModifyPostPageState();
}

class _ModifyPostPageState extends State<ModifyPostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.postDetails['content_title'];
    _contentController.text = widget.postDetails['content_detail'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

void _saveChanges() async {
  // Handle the logic to save changes, e.g., update the post via API.
  final modifiedPostDetails = {
    'title': _titleController.text,
    'content': _contentController.text,
  };

  final apiUrl = 'http://localhost:3000/api/modify/post/${widget.postId}';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      body: modifiedPostDetails,
    );

    if (response.statusCode == 200) {
      // If the API call is successful, you can handle the response here.
      print('Post successfully updated');
    } else {
      // If the API call fails, you can handle the error here.
      print('Failed to update post. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions that occur during the API call.
    print('Error during API call: $e');
  }

  // You can return the modified post details to the calling page.
  Navigator.pop(context, modifiedPostDetails);
}
}