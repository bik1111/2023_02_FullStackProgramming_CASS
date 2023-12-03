import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:http/http.dart' as http;

class CommunityFormWidget extends StatefulWidget {
  @override
  _CommunityFormWidgetState createState() => _CommunityFormWidgetState();
}

class _CommunityFormWidgetState extends State<CommunityFormWidget> {
  final TextEditingController _communityNameController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _communityNameController,
            decoration: InputDecoration(labelText: 'Community Name'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _hashtagsController,
            decoration: InputDecoration(labelText: 'Hashtags'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _createCommunity();
            },
            child: Text('Create Community'),
          ),
        ],
      ),
    );
  }

void _createCommunity() async {
  final String title = _communityNameController.text;
  final String hashtags = _hashtagsController.text;

  if (title.isNotEmpty) {
    final apiHandler = CreateCommunityApi('http://localhost:3000/api/community/create');
    final data = {'title': title, 'hashtags': hashtags};

    try {
      final http.Response response = await apiHandler.postHttpResponse(data);

      if (response.statusCode == 200) {
        // Successful POST request
        print('Community created successfully!');
      } else {
        // Handle error
        print('Error creating community. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during POST request: $e');
    }
  } else {
    print('Community name is empty. Please provide a community name.');
  }
}
}

