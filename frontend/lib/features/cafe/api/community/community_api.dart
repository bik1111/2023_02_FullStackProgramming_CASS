import 'dart:convert';
import 'package:http/http.dart' as http;


class CreateCommunityApi {
  late String _baseUrl;

  CreateCommunityApi(this._baseUrl);

  Future<http.Response> postHttpResponse(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl), // Remove 'http://' from the URL
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
      final response = await http.get(Uri.parse('http://' + _baseUrl));

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


class GETCommunityBoardInfoApi {

  late String _baseUrl;

  GETCommunityBoardInfoApi(this._baseUrl);

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


class ModifyCommunityPost {

  late String _baseUrl;

  ModifyCommunityPost(this._baseUrl);

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
        throw Exception('Failed to modify community post. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}


class DeleteCommunityPost {

    late String _baseUrl;

    DeleteCommunityPost(this._baseUrl);

    Future<http.Response> deleteHttpResponse(Map<String, dynamic> data) async {

      try {

        final response = await http.delete(Uri.parse('http://' + _baseUrl),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'},

        );

        if (response.statusCode == 200) {
          return response;
        } else {
          print('HTTP request failed with status: ${response.statusCode}');
          throw Exception('Failed to delete community. Server returned status ${response.statusCode}');
        }
      } catch (e) {
        print('Error during HTTP request: $e');
        throw e;
      }
    }
}

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchCommunities() async {
    final url = Uri.parse('http://127.0.0.1:3000/api/community');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['ok'] == true) {
          final List<dynamic> communityList = responseBody['data'];

          if (communityList is List) {
            // Ensure that the response is a List
            return communityList.cast<Map<String, dynamic>>();
          } else {
            print('Invalid format. Expected a List, but received: $communityList');
            return [];
          }
        } else {
          // Handle the case where the response indicates failure
          print('Failed to fetch communities. Message: ${responseBody['msg']}');
          return [];
        }
      } else {
        // Handle error, maybe throw an exception or return an empty list
        print('Error fetching communities. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during GET request: $e');
      return [];
    }
  }
}

class GetComment {
  late String _baseUrl;

  GetComment(this._baseUrl);

  Future<http.Response> getHttpResponse({
    required String communityId,
    required String contentId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('http://$_baseUrl/api/comment/get/$communityId/$contentId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to fetch comments. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}

class CreateComment {
  late String _baseUrl;

  CreateComment(this._baseUrl);

  Future<http.Response> postHttpResponse({
    required String communityId,
    required String contentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://$_baseUrl/api/comment/create/$communityId/$contentId'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to create comment. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}

class ModifyComment {
  late String _baseUrl;

  ModifyComment(this._baseUrl);

  Future<http.Response> putHttpResponse({
    required String communityId,
    required String contentId,
    required String commentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('http://$_baseUrl/api/comment/modify/$communityId/$contentId/$commentId'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to modify comment. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}


class DeleteComment {
  late String _baseUrl;

  DeleteComment(this._baseUrl);

  Future<http.Response> deleteHttpResponse({
    required String communityId,
    required String contentId,
    required String commentId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('http://$_baseUrl/api/comment/delete/$communityId/$contentId/$commentId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception('Failed to delete comment. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}

class DeleteCommunity {
  late String _baseUrl;

  DeleteCommunity(this._baseUrl);

  Future<http.Response> deleteHttpResponse({
    required int communityId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('http://$_baseUrl/api/delete/community/$communityId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception(
            'Failed to delete community. Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw e;
    }
  }
}