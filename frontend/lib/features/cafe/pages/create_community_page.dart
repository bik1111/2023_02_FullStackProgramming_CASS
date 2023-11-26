// create_community_page.dart

import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/widgets/community_form_widget.dart';

class CreateCommunityPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onCommunityCreated;
  CreateCommunityPage({Key? key, this.onCommunityCreated}) : super(key: key);

  @override
  _CreateCommunityPageState createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Community'),
      ),
      body: CommunityFormWidget(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreateCommunityPage(),
  ));
}
