import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/models/cafe.dart';
import 'package:full_stack_project/features/cafe/models/cafe_list.dart';
import 'package:full_stack_project/features/cafe/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../api/api_service.dart';

class AddCafePage extends StatefulWidget {
  final String username;

  AddCafePage({Key? key, required this.username}) : super(key: key);

  @override
  _AddCafePageState createState() => _AddCafePageState();
}

class _AddCafePageState extends State<AddCafePage> {
  final TextEditingController _cafeNameController = TextEditingController();
  List<Map<String, dynamic>> _cafeDataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새로운 카페를 추가하세요.'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '찾고 싶은 카페의 이름을 입력해보세요.',
                style: TextStyle(
                  fontFamily: 'montserrat_regular.ttf',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _cafeNameController,
                    decoration: InputDecoration(
                      hintText: '예: 강남역, 남산',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      _getCafeData().then((response) {
                        if (response.statusCode == 200) {
                          final Map<String, dynamic> responseData =
                              jsonDecode(response.body);

                          if (responseData['ok'] == true) {
                            final List<dynamic> dataList = responseData['data'];
                            setState(() {
                              _cafeDataList = dataList
                                  .cast<Map<String, dynamic>>()
                                  .map((cafe) => _cleanCafeData(cafe))
                                  .toList();
                            });
                          } else {
                            print('Error: ${responseData['msg']}');
                          }
                        } else {
                          print('Error: ${response.statusCode}');
                        }
                      });
                    },
                    child: Text('카페 찾기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 33, 120, 36),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _cafeDataList.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '검색 결과',
                          style: TextStyle(
                            fontFamily: 'montserrat_regular.ttf',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        for (var cafe in _cafeDataList)
                          _buildCafeRowWidget(cafe, context),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCafeRowWidget(Map<String, dynamic> cafe, BuildContext context) {
    return Container(
      child: Card(
        elevation: 2.0,
        color: Color.fromARGB(255, 64, 123, 40),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          title: Text(
            cafe['name'] ?? 'N/A',
            style: TextStyle(
              fontFamily: 'montserrat_regular.ttf',
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '주소: ${cafe['address'] ?? 'N/A'}',
                style: TextStyle(
                  fontFamily: 'montserrat_regular.ttf',
                  color: Colors.white,
                ),
              ),
              Text(
                '전화번호: ${cafe['number'] ?? 'N/A'}',
                style: TextStyle(
                  fontFamily: 'montserrat_regular.ttf',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () {
              _addToCafeList(cafe);
            },
            child: Text('Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              foregroundColor: const Color.fromARGB(255, 64, 123, 40),
            ),
          ),
        ),
      ),
    );
  }

  void _addToCafeList(Map<String, dynamic> cafe) {
    final cafeList = Provider.of<CafeList>(context, listen: false);

    double latitude = cafe['latitude'] != null
        ? double.tryParse(cafe['latitude']) ?? 0.0
        : 0.0;
    double longitude = cafe['longitude'] != null
        ? double.tryParse(cafe['longitude']) ?? 0.0
        : 0.0;

    cafeList.addCafe(Cafe(
      cafe_id: cafe['cafe_id'] ?? 'N/A',
      name: cafe['name'] ?? 'N/A',
      address: cafe['address'] ?? 'N/A',
      number: cafe['number'] ?? 'N/A',
      latitude: latitude,
      longitude: longitude,
    ));

    _navigateToHome(context, cafe, widget.username);
  }

  void _navigateToHome(
      BuildContext context, Map<String, dynamic> _cafeDataList, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          cafeData: _cafeDataList,
          showAddButton: false,
          username: username,
        ),
      ),
    ).then((_) {
      Navigator.pop(context);
    });
  }

  Map<String, dynamic> _cleanCafeData(Map<String, dynamic> cafe) {
    return {
      'name': cafe['name'] ?? 'N/A',
      'address': cafe['address'] ?? 'N/A',
      'number': cafe['number'] ?? 'N/A',
    };
  }

  Future<http.Response> _getCafeData() async {
    final cafeName = _cafeNameController.text;

    if (cafeName.isNotEmpty) {
      final encodedCafeName = Uri.encodeComponent(cafeName);
      final uri = Uri.parse('http://localhost:3000/api/cafe/search?cafeName=$encodedCafeName');
      final cafeApi = CafeApi(uri.toString());

      try {
        final response = await cafeApi.getHttpResponse();
        return response;
      } catch (e) {
        print('Error during HTTP request: $e');
        throw e;
      }
    } else {
      return http.Response('Cafe name is empty', 400);
    }
  }
}
