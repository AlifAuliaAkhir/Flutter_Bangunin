import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/proyekPDF_model.dart';

class ProyekService {
  static String? baseUrl = dotenv.env['API_URL'];

  static Future<List<Proyek>> getProyekSelesai() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Proyek'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data
          .map((json) => Proyek.fromJson(json))
          .where((proyek) => proyek.isSelesai == true)
          .toList();
    } else {
      throw Exception('Gagal mengambil data proyek');
    }
  }

  static Future<Uint8List> fetchPDF(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Proyek/$id/pdf'));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Gagal mengunduh PDF');
    }
  }
}