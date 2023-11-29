import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'create_community_page.dart';
import 'community_detail_page.dart';

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

  Future<http.Response> _fetchCommunities() async {
    final apiHandler = GETInfoCommunityApi('localhost:3000/api/community'); // Adjust the endpoint as needed

    try {
      final http.Response response = await apiHandler.getHttpResponse();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> communityList = responseBody['data'];

        setState(() {
          communities = communityList.cast<Map<String, dynamic>>();
        });
      } else {
        // Handle error
        print('Error fetching communities. Status code: ${response.statusCode}');
      }

      return response; // Add this line
    } catch (e) {
      // Handle exceptions
      print('Exception during GET request: $e');
      rethrow; // Rethrow the exception after handling it
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
              _buildCommunityCard(context, community),
            if (communities.isEmpty)
              Text(
                'No communities yet.',
                style: TextStyle(fontFamily: 'montserrat_regular.ttf'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 64, 123, 40),
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
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCommunityCard(BuildContext context, Map<String, dynamic> community) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          '${community['title'] ?? 'N/A'}',
          style: const TextStyle(fontFamily: 'montserrat_regular.ttf', fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${community['hashtags'] ?? 'N/A'}',
              style: const TextStyle(fontFamily: 'montserrat_regular.ttf'),
            ),
          ],
        ),
        onTap: () {
          // Navigate to the CommunityDetailPage when the ListTile is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommunityDetailPage(
                communityId: community['community_id'], // Replace 'id' with the actual identifier in your community map
              ),
            ),
          );
        },
      ),
    );
  }
}
