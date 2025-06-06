import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/toko_model.dart';

class TokoService {
  static Future<String> _getBaseUrl() async {
    // IP komputer (server ASP.NET)
    const ipServer = '192.168.1.11';
    return 'http://$ipServer:7109/api/Toko';
  }

  static Future<List<Toko>> fetchToko() async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((json) => Toko.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data toko. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  static Future<void> addToko(Toko toko) async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(toko.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Gagal menambahkan toko. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat menambahkan: $e');
    }
  }

  static Future<void> deleteToko(int id) async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 204) {
        throw Exception('Gagal menghapus toko. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat menghapus: $e');
    }
  }
}
