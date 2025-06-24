import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/toko_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TokoService {
  // Pastikan nilai ini tidak null
  static final String baseUrl =
      dotenv.env['API_URL'] ?? (throw Exception("API_URL not found in .env"));

  // GET all toko (untuk maps dan daftar CRUD)
  static Future<List<Toko>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/api/Toko'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Toko.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data toko');
    }
  }

  // GET toko by ID
  static Future<Toko> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Toko/$id'));
    if (response.statusCode == 200) {
      return Toko.fromJson(json.decode(response.body));
    } else {
      throw Exception('Data toko tidak ditemukan');
    }
  }

  // POST (tambah toko)
  static Future<void> create(Toko toko) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Toko'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toko.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal tambah toko');
    }
  }

  // PUT (update toko)
  static Future<void> update(int id, Toko toko) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Toko/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toko.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Gagal update toko');
    }
  }

  // DELETE toko
  static Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/Toko/$id'));
    if (response.statusCode != 204) {
      throw Exception('Gagal hapus toko');
    }
  }
}
