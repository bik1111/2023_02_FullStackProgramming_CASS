import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:full_stack_project/features/cafe/pages/modify_post_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityDetailPage extends StatefulWidget {
  final int communityId;

  CommunityDetailPage({required this.communityId});

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  List<Map<String, dynamic>>? posts;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchCommunityDetails();
  }

  Future<void> _fetchCommunityDetails() async {
    final apiUrl = 'http://localhost:3000/api/community/${widget.communityId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          posts = List<Map<String, dynamic>>.from(responseData['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Error fetching community details. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Exception during GET request: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${posts?.first['community_title'] ?? 'Community Detail'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: posts?.length ?? 0,
          itemBuilder: (context, index) {
            final post = posts![index];
            return _buildDetailCard(post['content_title'], post['content_detail'], post['content_id']);
          },
        ),
      ),
    );
  }

  Widget _buildDetailCard(String? title, String? detail, int? postId) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              title ?? 'N/A',
              style: TextStyle(
                fontFamily: 'montserrat_regular.ttf',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              detail ?? 'N/A',
              style: TextStyle(
                fontFamily: 'montserrat_regular.ttf',
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (postId != null) {
                      _handleModify(postId);
                    }
                  },
                  child: Text('Modify'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    if (postId != null) {
                      _handleDelete(postId);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

Future<bool> _showDeleteConfirmationDialog() async {
  bool confirmDeletion = false;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('삭제 확인'),
      content: Text('삭제하시겠습니까 ?'),
      actions: [
        TextButton(
          onPressed: () {
            // Cancel the deletion
            confirmDeletion = false;
            Navigator.pop(context);
          },
          child: Text('취소'),
        ),
        TextButton(
          onPressed: () {
            // Confirm the deletion
            confirmDeletion = true;
            Navigator.pop(context);
          },
          child: Text('확인'),
        ),
      ],
    ),
  );

  return confirmDeletion;
}

  void _deletePost(int postId) {
    // Implement the logic to delete the post with postId
    // Example: Call your API to delete the post
    // http.delete('http://localhost:3000/api/posts/$postId');
    // After deleting, you may want to refresh the UI to reflect the changes
    // _fetchCommunityDetails();
  }

void _handleModify(int postId) async {
  if (posts != null) {
    final postIndex = posts!.indexWhere((post) => post['content_id'] == postId);

    if (postIndex != -1) {
      final postDetails = posts![postIndex];
      final modifiedPostDetails = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifyPostPage(postId: postId, postDetails: postDetails),
        ),
      );

      if (modifiedPostDetails != null) {
        // Update the post details in the list
        setState(() {
          posts![postIndex]['content_title'] = modifiedPostDetails['title'];
          posts![postIndex]['content_detail'] = modifiedPostDetails['content'];
        });
      }
    }
  }
}


void _handleDelete(int postId) async {
  // Show a confirmation dialog before proceeding with the deletion
  bool confirmDeletion = await _showDeleteConfirmationDialog();

  if (confirmDeletion) {
    // Perform the deletion
    try {
      // Create an instance of DeleteCommunityPost with the appropriate base URL
      final deleteCommunityPost = DeleteCommunityPost('localhost:3000/api/delete/post/$postId');

      // Make the HTTP request to delete the community post
      final response = await deleteCommunityPost.deleteHttpResponse({});

      if (response.statusCode == 200) {
        // Deletion successful, refresh the UI
        _fetchCommunityDetails();
      } else {
        print('Failed to delete post. Status code: ${response.statusCode}');
        // Handle the deletion failure, e.g., show an error message to the user
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      // Handle any exceptions that occur during the HTTP request
    }
  }
}
}