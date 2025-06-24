import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'anggaran_screen.dart';
import 'toko_map_screen.dart';
import 'print_pdf_screen.dart';
import 'profile_user_screen.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  int _jumlahProyekBerjalan = 0;

  @override
  void initState() {
    super.initState();
    fetchProyekBelumSelesai();
  }

  Future<void> fetchProyekBelumSelesai() async {
    final baseUrl = dotenv.env['API_URL'];
    final url = Uri.parse('$baseUrl/api/Proyek/belum-selesai');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _jumlahProyekBerjalan = data.length;
        });
      }
    } catch (e) {
      print('Gagal mengambil data proyek belum selesai: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image full screen
          Positioned.fill(
            child: Image.asset(
              'lib/media/image.png',
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6C544),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BANGUN.in',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2AE00),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jumlah Project Berjalan',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$_jumlahProyekBerjalan Project',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => AnggaranScreen()),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tampilkan Project Berjalan',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white70),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004D40),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MenuButton(
                          icon: Icons.inventory_2_outlined,
                          label: 'Manajemen\nAnggaran',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AnggaranScreen()),
                          ),
                        ),
                        _MenuButton(
                          icon: Icons.map_outlined,
                          label: 'Temukan Toko\nSekitar',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TokoMapScreen()),
                          ),
                        ),
                        _MenuButton(
                          icon: Icons.picture_as_pdf,
                          label: 'Print PDF\n   ',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PrintPDFScreen()),
                          ),
                        ),
                        _MenuButton(
                          icon: Icons.person_outline,
                          label: 'Profile\nUser',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfileUserScreen(namaUser: '')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        'BANGUN.in',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mengelola, mencatat anggaran\ndan pemakaian,\nserta informasi toko bahan bangunan',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
