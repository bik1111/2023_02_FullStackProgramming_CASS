import 'dart:convert';

import 'package:http/http.dart' as http;

class CafeApi {
  late String _baseUrl;

  CafeApi(this._baseUrl);

  Future<http.Response> getHttpResponse() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to load cafe');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e; // Rethrow the exception if you want to handle it further up the call stack
    }
  }
}


class CreateCommunityApi {
  late String _baseUrl;

  CreateCommunityApi(this._baseUrl);

  Future<http.Response> postHttpResponse(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('http://' + _baseUrl), // Add 'http://' here
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to create community. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}


class GETInfoCommunityApi {
  late String _baseUrl;

  GETInfoCommunityApi(this._baseUrl);

  Future<http.Response> getHttpResponse() async {
    try {
      final response = await http.get(Uri.parse('http://' + _baseUrl)); // Add 'http://' here

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to fetch communities');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}
