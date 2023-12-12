import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/api/api_service.dart';
import 'package:http/http.dart' as http;

class CommunityFormWidget extends StatefulWidget {
  final VoidCallback? onCommunityCreated;

  CommunityFormWidget({Key? key, this.onCommunityCreated}) : super(key: key);

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
      final apiHandler = CreateCommunityApi('http://127.0.0.1:3000/api/community/create');
      final data = {'title': title, 'hashtags': hashtags};

      try {
        final http.Response response = await apiHandler.postHttpResponse(data);

        if (response.statusCode == 200) {
          // Call the callback to notify the parent widget
          widget.onCommunityCreated?.call();

          // Fetch communities immediately after creating one
          await _fetchCommunities();

          // Show completion dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Community Created'),
                content: Text('Your community has been created successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
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

  Future<void> _fetchCommunities() async {
    // Your logic for fetching communities goes here
  }
}

