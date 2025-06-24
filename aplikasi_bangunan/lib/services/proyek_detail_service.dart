import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/proyek_detail_model.dart';

class ProyekDetailService {
  static String? baseUrl = dotenv.env['API_URL'];

  static Future<ProyekDetailModel> getProyekDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/api/proyek"));

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      final data = list.firstWhere((e) => e['id'] == id);
      return ProyekDetailModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail proyek');
    }
  }

  static Future<void> addProductToProyek(int proyekId, int productId, int jumlah) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/proyek/$proyekId/add-product"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "productId": productId,
        "jumlah": jumlah,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan produk ke proyek');
    }
  }

  static Future<void> deleteProyek(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/api/proyek/$id"));
    if (response.statusCode != 204) {
      throw Exception('Gagal menghapus proyek');
    }
  }

  static Future<void> updateProyekStatus(int id, bool isSelesai) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/proyek/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"isSelesai": isSelesai}),
    );

    if (response.statusCode != 204) {
      throw Exception('Gagal update status proyek');
    }
  }
}
