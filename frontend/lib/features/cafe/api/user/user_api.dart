import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterNewUser {

  late String _baseUrl;

  RegisterNewUser(this._baseUrl);

  Future<http.Response> postHttpResponse(Map<String, dynamic> data) async {

    try {

      final response = await http.post(
        Uri.parse('http://' + _baseUrl),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
    );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to Register. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}

class LoginAPi {

  late String _baseUrl;

  LoginAPi(this._baseUrl);
  Future<http.Response> postHttpResponse(Map<String, dynamic> data) async {

      try {

        final response = await http.post(Uri.parse('http://' + _baseUrl),
          body: jsonEncode(data),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
        }
        );

        if (response.statusCode == 200) {
          return response;
        } else {
          print('HTTP request failed with status: ${response.statusCode}');
          throw Exception('Failed to Login. Server returned status ${response.statusCode}');
        }
      } catch (e) {
        print('Error during HTTP request: $e');
        throw e;
      }
    }
}