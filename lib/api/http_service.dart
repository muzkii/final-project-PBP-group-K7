import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  Future<http.Response> get({
    required String url,
    required Map<String, String> headers,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: headers);
    _handleResponse(response, url);

    return response;
  }

  Future<http.Response> post({
    required String url,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) async {
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    _handleResponse(response, url);

    return response;
  }

  Future<http.Response> put({
    required String url,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) async {
    final uri = Uri.parse(url);


    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception(
        'Failed to update data at $url. Status Code: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  Future<http.Response> delete({
    required String url,
    required Map<String, String> headers,
  }) async {
    final uri = Uri.parse(url);
    final response = await http.delete(uri, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception(
        'Failed to delete data at $url. Status Code: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
  
  Future<void> _handleResponse(http.Response response, String url) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Future.value();
    } else {
      throw Exception(
        'Request failed for $url. Status Code: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}

