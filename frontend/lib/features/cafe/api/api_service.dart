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