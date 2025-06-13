//MAPS TOKO
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/toko_model.dart';

// class TokoService {
//   static Future<String> _getBaseUrl() async {
//     // IP komputer (server ASP.NET)
//     const ipServer = '192.168.1.6';
//     return 'http://$ipServer:7109/api/Toko';
//   }

//   static Future<List<Toko>> fetchToko() async {
//     try {
//       final baseUrl = await _getBaseUrl();
//       final response = await http.get(Uri.parse(baseUrl));

//       if (response.statusCode == 200) {
//         final List<dynamic> body = json.decode(response.body);
//         return body.map((json) => Toko.fromJson(json)).toList();
//       } else {
//         throw Exception('Gagal memuat data toko. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Kesalahan jaringan: $e');
//     }
//   }

//   static Future<void> addToko(Toko toko) async {
//     try {
//       final baseUrl = await _getBaseUrl();
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(toko.toJson()),
//       );

//       if (response.statusCode != 201) {
//         throw Exception('Gagal menambahkan toko. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Kesalahan saat menambahkan: $e');
//     }
//   }

//   static Future<void> deleteToko(int id) async {
//     try {
//       final baseUrl = await _getBaseUrl();
//       final response = await http.delete(Uri.parse('$baseUrl/$id'));

//       if (response.statusCode != 204) {
//         throw Exception('Gagal menghapus toko. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Kesalahan saat menghapus: $e');
//     }
//   }
// }

//CRUD TOKO
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/toko_model.dart';

// class TokoService {
//   static const String baseUrl = 'http://192.168.1.6:7109/api/Toko';

//   static Future<List<Toko>> getAll() async {
//     final res = await http.get(Uri.parse(baseUrl));
//     if (res.statusCode == 200) {
//       final List data = json.decode(res.body);
//       return data.map((e) => Toko.fromJson(e)).toList();
//     } else {
//       throw Exception('Gagal memuat data toko');
//     }
//   }

//   static Future<Toko> getById(int id) async {
//     final res = await http.get(Uri.parse('$baseUrl/$id'));
//     if (res.statusCode == 200) {
//       return Toko.fromJson(json.decode(res.body));
//     } else {
//       throw Exception('Data toko tidak ditemukan');
//     }
//   }

//   static Future<void> create(Toko toko) async {
//     final res = await http.post(
//       Uri.parse(baseUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(toko.toJson()),
//     );
//     if (res.statusCode != 201) throw Exception('Gagal tambah toko');
//   }

//   static Future<void> update(int id, Toko toko) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/$id'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(toko.toJson()),
//     );
//     if (res.statusCode != 204) throw Exception('Gagal update toko');
//   }

//   static Future<void> delete(int id) async {
//     final res = await http.delete(Uri.parse('$baseUrl/$id'));
//     if (res.statusCode != 204) throw Exception('Gagal hapus toko');
//   }
// }

