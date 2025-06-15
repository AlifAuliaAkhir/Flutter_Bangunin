import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/toko_model.dart';

class TokoService {
  static const String baseUrl = 'http://192.168.1.12:7109/api/Toko';

  // 🔹 GET all toko (untuk maps dan daftar CRUD)
  static Future<List<Toko>> getAll() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Toko.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data toko');
    }
  }

  // 🔹 GET toko by ID
  static Future<Toko> getById(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      return Toko.fromJson(json.decode(res.body));
    } else {
      throw Exception('Data toko tidak ditemukan');
    }
  }

  // 🔹 POST (tambah toko)
  static Future<void> create(Toko toko) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toko.toJson()),
    );
    if (res.statusCode != 201) throw Exception('Gagal tambah toko');
  }

  // 🔹 PUT (update toko)
  static Future<void> update(int id, Toko toko) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toko.toJson()),
    );
    if (res.statusCode != 204) throw Exception('Gagal update toko');
  }

  // 🔹 DELETE toko
  static Future<void> delete(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 204) throw Exception('Gagal hapus toko');
  }
}
