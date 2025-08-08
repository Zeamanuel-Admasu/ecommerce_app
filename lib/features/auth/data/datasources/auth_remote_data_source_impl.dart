import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/features/auth/data/models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  final String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2';

@override
Future<UserModel> login({
  required String email,
  required String password,
}) async {
  final response = await client.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  print('🔍 Full login response body: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    final json = jsonDecode(response.body);
    final token = json['data']?['access_token'];

    // Try to get name if present, else fallback
    String name = '';
    if (json['data']?['user'] != null && json['data']['user']['name'] != null) {
      name = json['data']['user']['name'];
    } else {
      print('⚠️ Warning: name not found in response. Defaulting to empty.');
    }

    return UserModel(
      name: name,
      email: email, // you passed this during login
      token: token,
    );
  } else {
    throw Exception('Login failed: ${response.body}');
  }
}



  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    print('Signup response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null) {
        return UserModel.fromJson(json['data']);
      } else {
        throw Exception('Signup failed: Missing user data in response');
      }
    } else {
      throw Exception('Signup failed: ${response.body}');
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
