// import 'package:flutter/material.dart';
// import 'toko_map_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Beranda Aplikasi')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           children: [
//             _buildMenuCard(
//               context,
//               icon: Icons.map,
//               label: 'Lokasi Toko',
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const TokoMapScreen()),
//               ),
//             ),
//             _buildMenuCard(
//               context,
//               icon: Icons.attach_money,
//               label: 'Anggaran',
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const AnggaranScreen()),
//               ),
//             ),
//             _buildMenuCard(
//               context,
//               icon: Icons.picture_as_pdf,
//               label: 'Print PDF',
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const PrintPdfScreen()),
//               ),
//             ),
//             _buildMenuCard(
//               context,
//               icon: Icons.person,
//               label: 'Profil',
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ProfilePage()),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuCard(BuildContext context,
//       {required IconData icon, required String label, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 50, color: Theme.of(context).primaryColor),
//               const SizedBox(height: 10),
//               Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
