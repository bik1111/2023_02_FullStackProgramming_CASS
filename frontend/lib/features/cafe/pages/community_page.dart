import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'create_community_page.dart';

class CommunityPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onCommunityCreated;

  CommunityPage({Key? key, this.onCommunityCreated}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Map<String, dynamic>> communities = [];

  @override
  void initState() {
    super.initState();
    // Fetch community data when the widget is created
    _fetchCommunities();
  }

  Future<void> _fetchCommunities() async {
    final apiHandler = GETInfoCommunityApi('localhost:3000/api/community'); // Adjust the endpoint as needed

    try {
      final http.Response response = await apiHandler.getHttpResponse();

      if (response.statusCode == 200) {
        final List<dynamic> communityList = jsonDecode(response.body);

        setState(() {
          communities = communityList.cast<Map<String, dynamic>>();
        });
      } else {
        // Handle error
        print('Error fetching communities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during GET request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var community in communities)
              Card(
                child: Column(
                  children: [
                    Text('Title: ${community['title']}'),
                    Text('Hashtags: ${community['hashtags']}'),
                    // Add other community details as needed
                  ],
                ),
              ),
            if (communities.isEmpty)
              Text('No communities yet.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[200],
        onPressed: () {
          // Navigate to the CreateCommunityPage when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCommunityPage(
                onCommunityCreated: (createdCommunity) {
                  setState(() {
                    communities.add(createdCommunity);
                  });
                },
              ),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
