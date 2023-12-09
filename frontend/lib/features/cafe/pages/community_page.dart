import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/pages/community_detail_page.dart';
import 'package:full_stack_project/features/cafe/pages/create_community_page.dart';
import 'package:http/http.dart' as http;

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Map<String, dynamic>> communities = [];

  @override
  void initState() {
    super.initState();
    _fetchCommunities();
  }

  Future<void> _fetchCommunities() async {
    final apiUrl = 'http://localhost:3000/api/community'; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> communityList = responseBody['data'];

        setState(() {
          communities = communityList.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error fetching communities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during GET request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var community in communities) _buildCommunityCard(context, community),
                if (communities.isEmpty)
                  Text(
                    'No communities yet.',
                    style: TextStyle(fontFamily: 'montserrat_regular.ttf'),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          final createdCommunity = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCommunityPage(
                onCommunityCreated: () async {
                  await _fetchCommunities();
                },
              ),
            ),
          );

          if (createdCommunity != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Community Created'),
                  content: Text('Your community has been created successfully!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 64, 123, 40),
          ),
          padding: EdgeInsets.all(16.0),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityCard(BuildContext context, Map<String, dynamic> community) {
    double cardWidth = MediaQuery.of(context).size.width - 16.0;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2.0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ListTile(
            title: Row(
              children: [
                if (community['community_img'] != null)
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: Image.network(
                      community['community_img'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return Text('Error loading image');
                      },
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${community['title'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontFamily: 'montserrat_regular.ttf',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        '${community['hashtags'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontFamily: 'montserrat_regular.ttf',
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommunityDetailPage(communityId: community['community_id']),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CommunityPage(),
  ));
}
