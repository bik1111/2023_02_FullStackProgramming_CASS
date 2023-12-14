import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:full_stack_project/features/cafe/models/comment.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';

class EditCommentScreen extends StatefulWidget {
  final Comment comment;
  final Function(String, Comment) onEdit; // Update the callback type

  EditCommentScreen({required this.comment, required this.onEdit});

  @override
  _EditCommentScreenState createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  TextEditingController editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editController.text = widget.comment.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: editController,
              decoration: InputDecoration(
                hintText: 'Edit your comment...',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    Comment editedComment = widget.comment.copyWith(content: editController.text);

    try {
      final modifyComment = ModifyComment('localhost:3000');

      final response = await modifyComment.putHttpResponse(
        communityId: editedComment.communityId.toString(),
        contentId: editedComment.contentId.toString(),
        commentId: editedComment.commentId.toString(),
        data: {
          'content': editedComment.content,
        },
      );

      if (response.statusCode == 200) {
        widget.onEdit(editedComment.content, widget.comment); // Pass the comment explicitly
        Navigator.pop(context, editedComment);
      } else {
        print('Failed to edit comment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }
}
