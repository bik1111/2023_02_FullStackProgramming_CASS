import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:full_stack_project/features/cafe/models/comment.dart';
import 'package:full_stack_project/features/cafe/widgets/community/edit_comment_screen.dart';

class CommentSection extends StatefulWidget {
  final int postId;
  final String postTitle;
  final String postDetail;
  final int communityId;

  CommentSection({
    required this.postId,
    required this.postTitle,
    required this.postDetail,
    required this.communityId,
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  TextEditingController commentController = TextEditingController();
  List<Comment> comments = []; // Store the list of comments
  StreamController<List<Comment>> _commentsController = StreamController<List<Comment>>();

  @override
  void dispose() {
    _commentsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('댓글 작성'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postTitle,
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      widget.postDetail,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Comment>>(
              // Replace with the actual method to fetch comments from the server
              future: _fetchComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No comments available.'),
                        SizedBox(height: 10.0),
                        Text('Be the first to add a comment!'),
                      ],
                    ),
                  );
                } else {
                  // Display the comments
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Comment comment = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            subtitle: Text(
                              comment.content,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editComment(comment);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteComment(comment);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Material(
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.blue,
                  child: IconButton(
                    onPressed: () {
                      _addComment();
                    },
                    icon: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Comment>> _fetchComments() async {
    try {
      // Replace 'localhost:3000' with your actual API base URL
      final getComment = GetComment('localhost:3000');

      final response = await getComment.getHttpResponse(
        communityId: widget.communityId.toString(),
        contentId: widget.postId.toString(),
      );

      if (response.statusCode == 200) {
        final List<Comment> comments = [];
        final List<dynamic> commentData = jsonDecode(response.body)['data'];

        for (var commentInfo in commentData) {
          comments.add(Comment(
            commentId: commentInfo['comment_id'],
            content: commentInfo['content'],
            contentId: commentInfo['content_id'],
            communityId: commentInfo['community_id'],
          ));
        }

        // Add the comments to the StreamController
        _commentsController.add(comments);

        return comments;
      } else {
        print('Failed to fetch comments. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch comments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }

  void _addComment() async {
    String communityId = widget.communityId.toString();
    String newComment = commentController.text;
    int contentId = widget.postId;

    if (newComment.isNotEmpty) {
      CreateComment createComment = CreateComment('localhost:3000');

      try {
        await createComment.postHttpResponse(
          communityId: communityId,
          contentId: contentId.toString(),
          data: {'content': newComment},
        );

        Comment newCommentObject = Comment(
          commentId: _generateRandomCommentId(),
          content: newComment,
          contentId: contentId,
          communityId: int.parse(communityId),
        );

        setState(() {
          comments.add(newCommentObject);
          _commentsController.add(comments.toList());
        });

        // Clear the text field after successfully adding a comment
        commentController.clear();
      } catch (e) {
        print('Error creating comment: $e');
      }
    }
  }

  int _generateRandomCommentId() {
    Random random = Random();
    return random.nextInt(1000); // Adjust the range as needed
  }

  void _editComment(Comment comment) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCommentScreen(
          comment: comment,
          onEdit: _updateCommentInList,
        ),
      ),
    );
  }

  void _updateCommentInList(String editedText, Comment comment) {
    setState(() {
      int index = comments.indexWhere((element) => element.commentId == comment.commentId);

      if (index != -1) {
        comments[index].content = editedText;
      }
    });
  }

  void _deleteComment(Comment comment) async {
    try {
      final deleteComment = DeleteComment('localhost:3000');

      final response = await deleteComment.deleteHttpResponse(
        communityId: comment.communityId.toString(),
        contentId: comment.contentId.toString(),
        commentId: comment.commentId.toString(),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Fetch the updated comments or handle the UI update as needed
        });
      } else {
        print('Failed to delete comment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }
}
