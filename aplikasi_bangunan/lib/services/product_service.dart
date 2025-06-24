import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  static final String baseUrl =
      dotenv.env['API_URL'] ?? (throw Exception("API_URL not found in .env"));

  static String get endpoint => '$baseUrl/api/Product';

  // 🔸 GET all products
  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }

  // 🔸 GET product by ID
  static Future<Product> fetchProductBynamaProduk(String namaProduk) async {
    try {
      final response = await http.get(Uri.parse('$endpoint/$namaProduk'));

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Produk tidak ditemukan. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan: $e');
    }
  }

  // 🔸 POST (add) product
  static Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Gagal menambahkan produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat menambahkan produk: $e');
    }
  }

  // 🔸 PUT (update) product
  static Future<void> updateProduct(int id, Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Gagal update produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat update produk: $e');
    }
  }

  // 🔸 DELETE product
  static Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$endpoint/$id'));

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Gagal menghapus produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat menghapus produk: $e');
    }
  }
}
