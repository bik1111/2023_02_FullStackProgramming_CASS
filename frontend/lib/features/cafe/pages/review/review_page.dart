import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/models/cafe.dart';
import 'package:full_stack_project/features/cafe/pages/review/create_reveiw.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaginationButtons extends StatelessWidget {
  final int startPage;
  final int endPage;
  final int currPage;
  final int totalPage;
  final Function(int) onPageSelected;

  PaginationButtons({
    required this.startPage,
    required this.endPage,
    required this.currPage,
    required this.totalPage,
    required this.onPageSelected,
  });

  Widget _buildPageButton(int page, String label, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          onPageSelected(page);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    int adjustedStartPage = startPage >= 1 ? startPage : 1;

    for (int i = adjustedStartPage; i < adjustedStartPage + 4 && i <= totalPage; i++) {
      buttons.add(_buildPageButton(i, i.toString()));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (adjustedStartPage > 1) _buildPageButton(adjustedStartPage - 1, '이전', textColor: Colors.black),
        ...buttons,
        if (adjustedStartPage + 4 <= totalPage) _buildPageButton(adjustedStartPage + 4, '다음', textColor: Colors.black),
      ],
    );
  }
}

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late List<Cafe> _cafeList;
  late List<Cafe> _filteredCafeList;
  late int _currentPage;
  late int _totalPages;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cafeList = [];
    _filteredCafeList = [];
    _currentPage = 1;
    _totalPages = 1;
    _scrollController = ScrollController();
    _fetchCafeList(_currentPage);
  }

  Future<void> _fetchCafeList(int page) async {
    final apiUrl = 'http://127.0.0.1:3000/api/cafe/$page/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final cafesData = responseData['data']['myresult'];

        final cafes = (cafesData as List<dynamic>)
            .map((json) => Cafe.fromJson(json as Map<String, dynamic>))
            .toList();

        final pageInfo = responseData['data'];

        final parsedCurrPage = int.parse(pageInfo['currPage'].toString());
        final parsedTotalPage = int.parse(pageInfo['totalPage'].toString());

        final validCurrPage = parsedCurrPage >= 1 ? parsedCurrPage : 1;
        final validTotalPage = parsedTotalPage >= 1 ? parsedTotalPage : 1;

        setState(() {
          _cafeList.clear();
          _cafeList.addAll(cafes);
          _filteredCafeList = List.from(_cafeList);
          _currentPage = validCurrPage;
          _totalPages = validTotalPage;
        });
      } else {
        print('Failed to load cafe information. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during cafe data fetching: $e');
    }
  }

  Future<void> _loadMoreCafes(int nextPage) async {
    if (nextPage <= _totalPages) {
      await _fetchCafeList(nextPage);
    }
  }

  void _onPageSelected(int page) {
    _fetchCafeList(page);
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Review Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
                  _loadMoreCafes(_currentPage + 1);
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredCafeList.length,
                itemBuilder: (context, index) {
                  final cafe = _filteredCafeList[index];
                  return _buildCafeCard(cafe, context);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PaginationButtons(
              startPage: _currentPage - 2,
              endPage: _currentPage + 2,
              currPage: _currentPage,
              totalPage: _totalPages,
              onPageSelected: _onPageSelected,
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
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Address: ${cafe.address}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              'Number: ${cafe.number}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
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
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
              child: Text('Leave a Review'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReviewPage(),
  ));
}
