import 'dart:convert';
import 'package:http/http.dart' as http;

class createReviewApi {

  late String _baseUrl;

  createReviewApi(this._baseUrl);

  Future<http.Response> postHttpResponse(Map<String, dynamic> data) async {

    try {

      final response = await http.post(Uri.parse('http://' + _baseUrl),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},

      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to create review. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}

class GetReviewEachCafe {

  late String _baseUrl;

  GetReviewEachCafe(this._baseUrl);

  Future<http.Response> getHttpResponse() async {

    try {
      final response = await http.get(Uri.parse('http://' + _baseUrl));

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to fetch communities');
      }
    } catch(e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}

class ModifyReview {
  late String _baseUrl;

  ModifyReview(this._baseUrl);

  Future<http.Response> putHttpResponse(Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('http://' + _baseUrl), // Include reviewId in the URL
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to modify review. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}



class DeleteReview {
  late String _baseUrl;

  DeleteReview(this._baseUrl);

  Future<http.Response> deleteReview(String reviewId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://$_baseUrl/api/delete/$reviewId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to delete review. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}