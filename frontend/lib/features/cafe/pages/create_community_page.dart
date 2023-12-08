import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;

class CreateCommunityPage extends StatefulWidget {
  final VoidCallback? onCommunityCreated;

  CreateCommunityPage({Key? key, this.onCommunityCreated}) : super(key: key);

  @override
  _CreateCommunityPageState createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final TextEditingController _communityNameController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  Uint8List? _selectedImageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            makeFilePicker(), // Add the file picker UI
            SizedBox(height: 16),
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
              onPressed: () async {
                await _createCommunity();
              },
              child: Text('Create Community'),
            ),
          ],
        ),
      ),
    );
  }

Container makeFilePicker() {
  return Container(
    height: 200,
    width: 400,
    decoration: BoxDecoration(
      border: Border.all(width: 5, color: _selectedImageBytes != null ? Colors.green : Colors.grey[400]!),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            await _pickImage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Find and Upload",
                style: TextStyle(fontWeight: FontWeight.bold, color: _selectedImageBytes != null ? Colors.green : Colors.grey[400]!, fontSize: 20,),
              ),
              Icon(Icons.upload_rounded, color: _selectedImageBytes != null ? Colors.green : Colors.grey[400]!),
            ],
          ),
        ),
        Text("(*.jpg, *.jpeg, *.png)", style: TextStyle(color: _selectedImageBytes != null ? Colors.green : Colors.grey[400]!),),
        const SizedBox(height: 10,),
        _selectedImageBytes != null
            ? Image.memory(
                _selectedImageBytes!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
            : Container(),
        const SizedBox(height: 10,),
        Text(_selectedImageBytes != null ? "Now File Name: selected_image.jpg" : "No file selected", style: TextStyle(color: _selectedImageBytes != null ? Colors.green : Colors.grey[400]!),),
      ],
    ),
  );
}

// Inside _pickImage method
Future<void> _pickImage() async {
  try {
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'jpeg', 'png'],
    );

    final XFile? pickedImage = await openFile(acceptedTypeGroups: [typeGroup]);

    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  } catch (e) {
    print('Error picking image: $e');
  }
}


Future<void> _createCommunity() async {
  final String title = _communityNameController.text;
  final String hashtags = _hashtagsController.text;

  if (title.isNotEmpty) {
    final apiEndpoint = 'http://localhost:3000/api/community/create';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiEndpoint));
      request.fields['title'] = title;
      request.fields['hashtags'] = hashtags;

      if (_selectedImageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'img',
            _selectedImageBytes!,
            filename: 'selected_image.jpg',
          ),
        );
      }

      // Log the request details
      print('Request URL: $apiEndpoint');
      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files}');

      final http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        widget.onCommunityCreated?.call();
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
      } else {
        print('Error creating community. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during POST request: $e');
    }
  } else {
    print('Community name is empty. Please provide a community name.');
  }
}
}