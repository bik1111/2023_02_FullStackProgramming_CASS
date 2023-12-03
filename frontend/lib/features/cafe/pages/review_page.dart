import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/pages/create_reveiw.dart';
import 'package:http/http.dart' as http;
import 'package:full_stack_project/features/cafe/models/cafe.dart'; // Import the Cafe class from the models file

class ReviewPage extends StatelessWidget {
  get cafe => null;

Future<List<Cafe>> _fetchCafeList() async {
  final apiUrl = 'http://localhost:3000/api/cafe';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body)['data'];
    return responseData
        .map((json) => Cafe.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load cafe information');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Review Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.rate_review),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewFormPage(cafe: cafe),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchCafeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Text('No cafe data available'),
            );
          } else {
            final cafeList = snapshot.data as List<Cafe>;
            return ListView.builder(
              itemCount: cafeList.length,
              itemBuilder: (context, index) {
                final cafe = cafeList[index];
                return _buildCafeCard(cafe, context);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCafeCard(Cafe cafe, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cafe.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 27, 110, 30),
              ),
            ),
            SizedBox(height: 8.0),
            Text('Address: ${cafe.address}'),
            SizedBox(height: 4.0),
            Text('Number: ${cafe.number}'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewFormPage(cafe: cafe),
                  ),
                );
              },
              child: Text('Leave a Review'),
            ),
          ],
        ),
      ),
    );
  }
}
