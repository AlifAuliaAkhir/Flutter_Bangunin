import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/proyek_model.dart';

class ProyekService {
  static final String baseUrl = dotenv.env['API_URL']!;

  static Future<List<Proyek>> fetchProyekSelesai() async {
    final response = await http.get(Uri.parse("$baseUrl/proyek/selesai"));
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Proyek.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat proyek selesai");
    }
  }

  static Future<List<Proyek>> fetchProyekBelumSelesai() async {
    final response = await http.get(Uri.parse("$baseUrl/proyek/belum-selesai"));
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Proyek.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat proyek berjalan");
    }
  }

  static Future<void> deleteProyek(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/proyek/$id"));
    if (response.statusCode != 204) {
      throw Exception("Gagal menghapus proyek");
    }
  }

  static Future<void> updateProyek(int id, bool isSelesai) async {
    final response = await http.put(
      Uri.parse("$baseUrl/proyek/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"isSelesai": isSelesai}),
    );

    if (response.statusCode != 204) {
      throw Exception("Gagal mengupdate status proyek");
    }
  }

  static Future<void> addProductToProyek(int id, int productId, int jumlah) async {
    final response = await http.post(
      Uri.parse("$baseUrl/proyek/$id/add-product"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"productId": productId, "jumlah": jumlah}),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menambahkan produk ke proyek");
    }
  }
}