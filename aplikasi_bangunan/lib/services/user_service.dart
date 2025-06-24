import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  static String? baseUrl = dotenv.env['API_URL'];

  static Future<Map<String, dynamic>> login(String nama, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/Auth/login"), 
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nama": nama, "password": password}),
      );

      // Tambahan debug log
      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        } else {
          throw Exception("Body kosong dari server");
        }
      } else {
        throw Exception("Login gagal. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Gagal login: $e");
    }
  }

  static Future<http.Response> register(String nama, String password) {
    return http.post(
      Uri.parse("$baseUrl/api/Auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nama": nama, "password": password, "role": "User"}),
    );
  }

  static Future<http.Response> resetPassword(String nama, String passwordLama, String passwordBaru) {
    return http.post(
      Uri.parse("$baseUrl/api/Auth/ganti-password-user"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": nama,
        "passwordLama": passwordLama,
        "passwordBaru": passwordBaru,
      }),
    );
  }
}
