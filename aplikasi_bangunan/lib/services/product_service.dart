import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static Future<String> _getBaseUrl() async {
    // Ganti dengan IP server kamu yang sesuai
    const ipServer = '192.168.1.4';
    return 'http://$ipServer:7109/api/Product';
  }

  // 🔸 GET all products
  static Future<List<Product>> fetchProducts() async {
    try {
      final url = await _getBaseUrl();
      final response = await http.get(Uri.parse(url));

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
  static Future<Product> fetchProductById(int id) async {
    try {
      final url = await _getBaseUrl();
      final response = await http.get(Uri.parse('$url/$id'));

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
      final url = await _getBaseUrl();
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama_Product': product.namaProduct,
          'harga': product.harga,
          'satuanBarang': product.satuanBarang,
        }),
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
      final url = await _getBaseUrl();
      final response = await http.put(
        Uri.parse('$url/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama_Product': product.namaProduct,
          'harga': product.harga,
          'satuanBarang': product.satuanBarang,
        }),
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
      final url = await _getBaseUrl();
      final response = await http.delete(Uri.parse('$url/$id'));

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Gagal menghapus produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat menghapus produk: $e');
    }
  }
}
