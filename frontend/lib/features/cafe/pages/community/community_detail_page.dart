import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:full_stack_project/features/cafe/pages/community/create_post_page.dart';
import 'package:full_stack_project/features/cafe/pages/community/modify_post_page.dart';
import 'package:full_stack_project/features/cafe/widgets/community/comment_section.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityDetailPage extends StatefulWidget {
  final int communityId;
  final String? communityImage;

  CommunityDetailPage({required this.communityId, this.communityImage});

  get communityImageBytes => null;

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
    final apiUrl = 'http://127.0.0.1:3000/api/community/${widget.communityId}';

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
        title: Text(posts?.isNotEmpty == true ? posts!.first['community_title'] ?? 'Community Detail' : 'Community Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _handleAddPost();
            },
          ),
        ],
      ),
   body: Stack(
  children: [
    if (widget.communityImage != null)
      Positioned.fill(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.83), // Adjust the opacity as needed
            BlendMode.dstATop,
          ),
          child: Image.network(
            widget.communityImage!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: posts?.isEmpty ?? true
          ? _buildEmptyStateWidget()
          : ListView.builder(
              itemCount: posts!.length,
              itemBuilder: (context, index) {
                final post = posts![index];
                return _buildDetailCard(post['content_title'], post['content_detail'], post['content_id']);
              },
            ),
    ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _handleAddPost();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    '글 작성하기',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildDetailCard(String? title, String? detail, int? postId) {
  return GestureDetector(
    onTap: () {
      if (postId != null) {
        String postTitle = title ?? 'N/A';
        String postDetail = detail ?? 'N/A';
        _navigateToComments(postId, postTitle, postDetail);
      }
    },
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.0),
            Text(
              title ?? 'N/A',
              style: TextStyle(
                fontFamily: 'montserrat_regular.ttf',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              detail ?? 'N/A',
              style: TextStyle(
                fontFamily: 'montserrat_regular.ttf',
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // 정렬 방향을 오른쪽으로 지정
              children: [
                ElevatedButton(
                  onPressed: () {
                    _handleModify(postId!);
                  },
                  child: Text('수정'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _handleDelete(postId!);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Text('삭제'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildEmptyStateWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            posts == null || posts!.isEmpty
                ? 'No posts available'
                : 'No posts available for this community',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    bool confirmDeletion = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () {
              // Cancel the deletion
              confirmDeletion = false;
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Confirm the deletion
              confirmDeletion = true;
              Navigator.pop(context);
            },
            child: Text('Confirm'),
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
    // Implement the logic for modifying a post
    // Navigate to the ModifyPostPage with the post details
    if (posts != null) {
      final postIndex = posts!.indexWhere((post) => post['content_id'] == postId);

      if (postIndex != -1) {
        final postDetails = posts![postIndex];
        final modifiedPostDetails = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModifyPostPage(postId: postId, postDetails: postDetails, communityId: widget.communityId),
          ),
        );

        if (modifiedPostDetails != null) {
          setState(() {
            posts![postIndex]['content_title'] = modifiedPostDetails['title'];
            posts![postIndex]['content_detail'] = modifiedPostDetails['content'];
          });
        }
      }
    }
  }

  void _handleDelete(int postId) async {
    // Implement the logic for deleting a post
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

  void _handleAddPost() async {
    // Navigate to the CreatePostPage to add a new post
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => YourWritePostScreen(communityId: widget.communityId),
      ),
    );
  }

  void _navigateToComments(int postId, String postTitle, String postDetail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentSection(
          communityId: widget.communityId,
          postId: postId,
          postTitle: postTitle,
          postDetail: postDetail,
        ),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      routes: {
        '/': (context) => CommunityDetailPage(communityId: 1),
        // Add other routes if necessary
      },
    ));
  }
}
