// community_detail_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'create_post_page.dart'; // Import your Create Post screen file

class CommunityDetailPage extends StatefulWidget {
  final int communityId;

  CommunityDetailPage({required this.communityId});

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  Map<String, dynamic>? communityDetails;

  @override
  void initState() {
    super.initState();
    _fetchCommunityDetails();
  }

  Future<http.Response> _fetchCommunityDetails() async {
    final apiUrl = 'http://localhost:3000/api/community/${widget.communityId}';

    late http.Response response;

    try {
      response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          communityDetails = responseData['data'][0];
        });
      } else {
        print('Error fetching community details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during GET request: $e');
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${communityDetails?['community_title'] ?? 'Community Detail'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (communityDetails != null)
              _buildDetailCard(
                communityDetails?['content_title'],
                communityDetails?['content_detail'],
              ),
            if (communityDetails == null)
              Center(
                child: Text(
                  'Loading community details...',
                  style: TextStyle(
                    fontFamily: 'montserrat_regular.ttf',
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            Container(
              width: 100.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YourWritePostScreen(communityId: widget.communityId),
                    ),
                  );
                },
                child: Text('글 쓰기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String? title, String? detail) {
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
          ],
        ),
      ),
    );
  }
}
