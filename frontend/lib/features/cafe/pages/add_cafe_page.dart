import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:full_stack_project/features/cafe/models/cafe.dart';
import 'package:full_stack_project/features/cafe/models/cafe_list.dart';
import 'package:full_stack_project/features/cafe/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../api/api_service.dart';

class AddCafePage extends StatefulWidget {
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
              TextField(
                controller: _cafeNameController,
                decoration: InputDecoration(
                  labelText: '카페명을 입력하세요.',
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 120.0,
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
                            // Handle cases where 'ok' is false or other conditions
                            print('Error: ${responseData['msg']}');
                          }
                        } else {
                          // Handle other status codes if needed
                          print('Error: ${response.statusCode}');
                        }
                      });
                    },
                    child: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 33, 120, 36),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _cafeDataList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _cafeDataList.length,
                      itemBuilder: (context, index) {
                        return _buildCafeRowWidget(_cafeDataList[index], context);
                      },
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
            style: TextStyle(fontFamily: 'montserrat_regular.ttf', fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '주소: ${cafe['address'] ?? 'N/A'}',
                style: TextStyle(fontFamily: 'montserrat_regular.ttf', color: Colors.white),
              ),
              Text(
                '전화번호: ${cafe['number'] ?? 'N/A'}',
                style: TextStyle(fontFamily: 'montserrat_regular.ttf', color: Colors.white),
              ),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () {
              _addToCafeList(cafe); // 새로운 콜백 호출
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

    // 선택한 카페를 CafeList에 추가
    cafeList.addCafe(Cafe(
      name: cafe['name'] ?? 'N/A',
      address: cafe['address'] ?? 'N/A',
      number: cafe['number'] ?? 'N/A',
    ));

    // 선택한 카페 정보를 HomePage로 전달
    _navigateToHome(context, cafe);
  }

void _navigateToHome(BuildContext context, Map<String, dynamic> cafeData) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(cafeData: cafeData, showAddButton: false),
    ),
  ).then((_) {
    Navigator.pop(context);
  });
}


  Map<String, dynamic> _cleanCafeData(Map<String, dynamic> cafe) {
    // Handle null or missing fields here
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
    print('Encoded Cafe Name: $encodedCafeName');

    final uri = Uri.parse('http://localhost:3000/api/cafe/search?cafeName=$encodedCafeName');
    print('Final URL: $uri');

    final cafeApi = CafeApi(uri.toString());

    try {
      final response = await cafeApi.getHttpResponse();

      // Format the JSON response for better readability
      final encoder = JsonEncoder.withIndent('  '); // Use two spaces for indentation
      final formattedJson = encoder.convert(jsonDecode(response.body));
      print('Formatted JSON:\n$formattedJson');

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

