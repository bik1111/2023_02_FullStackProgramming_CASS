import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:full_stack_project/features/cafe/models/cafe.dart';
import 'package:full_stack_project/features/cafe/pages/create_reveiw.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late List<Cafe> _cafeList;
  late List<Cafe> _filteredCafeList;

  @override
  void initState() {
    super.initState();
    _fetchCafeList();
  }

  Future<void> _fetchCafeList() async {
    final apiUrl = 'http://localhost:3000/api/cafe';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body)['data'];
      setState(() {
        _cafeList = responseData.map((json) => Cafe.fromJson(json)).toList();
        _filteredCafeList = List.from(_cafeList);
      });
    } else {
      throw Exception('Failed to load cafe information');
    }
  }

  void _filterAndSortCafeList(String query) {
    setState(() {
      _filteredCafeList = _cafeList
          .where((cafe) => cafe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      _filteredCafeList.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Review Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterAndSortCafeList,
              decoration: InputDecoration(
                labelText: '원하는 카페를 검색해 보세요.',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCafeList.length,
              itemBuilder: (context, index) {
                final cafe = _filteredCafeList[index];
                return _buildCafeCard(cafe, context);
              },
            ),
          ),
        ],
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
              child: Text('리뷰 남기기'),
            ),
          ],
        ),
      ),
    );
  }
}
