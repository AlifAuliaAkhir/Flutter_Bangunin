import 'package:flutter/material.dart';
import 'crud_menu_screen.dart';
import 'toko_map_screen.dart';
import 'profile_admin_screen.dart';
import 'data_user_screen.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image fullscreen
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
                // Header tanpa background kuning
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'BANGUN.in',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255), 
                      ),
                    ),
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
                          label: 'Manajemen\nProduk & Toko',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CrudMenuScreen()),
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
                          icon: Icons.person_outline,
                          label: 'Profile\nAdmin',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfileAdminScreen()),
                          ),
                        ),
                        _MenuButton(
                          icon: Icons.lock_outline,
                          label: 'Akun\nDeveloper',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DataUserScreen()),
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
