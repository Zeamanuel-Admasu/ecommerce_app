import 'dart:convert';

import 'package:http/http.dart' as http;

Future<T> handleHttpResponse<T>(
  http.Response response,
  T Function(Map<String, dynamic>) fromJson,
) async {
  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    if (decoded is List) {
      return decoded.map((e) => fromJson(e)).toList() as T;
    } else {
      return fromJson(decoded);
    }
  } else {
    throw Exception('Server error: ${response.statusCode}');
  }
}
