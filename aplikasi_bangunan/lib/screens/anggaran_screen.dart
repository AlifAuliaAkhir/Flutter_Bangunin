import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'detail_anggaran_screen.dart';

class AnggaranScreen extends StatefulWidget {
  @override
  _AnggaranScreenState createState() => _AnggaranScreenState();
}

class _AnggaranScreenState extends State<AnggaranScreen> {
  List<dynamic> proyekBerjalan = [];
  List<dynamic> proyekSelesai = [];
  final String? baseUrl = dotenv.env['API_URL'];

  @override
  void initState() {
    super.initState();
    fetchProyek();
  }

  Future<void> fetchProyek() async {
    try {
      final berjalanRes = await http.get(Uri.parse("$baseUrl/api/proyek/belum-selesai"));
      final selesaiRes = await http.get(Uri.parse("$baseUrl/api/proyek/selesai"));

      setState(() {
        proyekBerjalan = jsonDecode(berjalanRes.body);
        proyekSelesai = jsonDecode(selesaiRes.body);
      });
    } catch (e) {
      print("Error fetch proyek: $e");
    }
  }

  Future<void> deleteProyek(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/api/proyek/$id"));
      if (res.statusCode == 204) {
        fetchProyek();
      }
    } catch (e) {
      print("Gagal hapus proyek: $e");
    }
  }

  Future<void> toggleStatus(int id, bool isSelesai) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/api/proyek/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"isSelesai": !isSelesai}),
      );
      if (res.statusCode == 204) {
        fetchProyek();
      }
    } catch (e) {
      print("Gagal update proyek: $e");
    }
  }

  Future<void> tambahProyekBaru() async {
    String namaProyek = '';
    final TextEditingController _controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Proyek Baru"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: "Masukkan nama proyek"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () async {
              namaProyek = _controller.text.trim();
              if (namaProyek.isNotEmpty) {
                Navigator.pop(context);
                final res = await http.post(
                  Uri.parse('$baseUrl/api/proyek'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    "nama": namaProyek,
                    "isSelesai": false,
                    "proyekProducts": [] // Kosong awalnya, bisa ditambah belakangan
                  }),
                );
                if (res.statusCode == 201) {
                  fetchProyek();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proyek berhasil ditambahkan')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menambahkan: ${res.body}')),
                  );
                }
              }
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  Widget buildProyekSection(String title, List<dynamic> proyekList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text("$title\n${proyekList.length} Project",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.amber[800],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
          ),
          child: Column(
            children: proyekList.map((p) {
              return ListTile(
                title: Text(p['nama'], style: const TextStyle(color: Colors.white)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => deleteProyek(p['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.update, color: Colors.white),
                      onPressed: () => toggleStatus(p['id'], p['isSelesai']),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailAnggaranScreen(
                      proyekId: p['id'],
                      namaProyek: p['nama'],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Manajemen Anggaran"),
        actions: [
          IconButton(
            onPressed: tambahProyekBaru,
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: "Tambah Proyek",
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            buildProyekSection("Project Berjalan", proyekBerjalan),
            const SizedBox(height: 24),
            buildProyekSection("Project Selesai", proyekSelesai),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
