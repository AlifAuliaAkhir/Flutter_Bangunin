
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:restart_app/restart_app.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   File? _profileImage;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedProfileImage();
//   }

//   Future<void> _loadSavedProfileImage() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/profile.jpg');
//     if (await file.exists()) {
//       setState(() {
//         _profileImage = file;
//       });
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: source, imageQuality: 80);
//     if (picked != null) {
//       final dir = await getApplicationDocumentsDirectory();
//       await File(picked.path).copy('${dir.path}/profile.jpg');
//       Restart.restartApp(); // Restart to reload updated image
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFEF7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFFD54F),
//         elevation: 0,
//         title: const Center(
//           child: Text(
//             "Profile",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         automaticallyImplyLeading: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 35,
//                   backgroundImage:
//                       _profileImage != null ? FileImage(_profileImage!) : null,
//                   child: _profileImage == null
//                       ? const Icon(Icons.person, size: 40)
//                       : null,
//                 ),
//                 const SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       "Welcome, Alif Aulia !",
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "alifaulia@gmail.com",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),

//             // Ganti Password
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: ListTile(
//                 leading: const Icon(Icons.lock_outline),
//                 title: const Text(
//                   "Ganti Password",
//                   style: TextStyle(
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 trailing: const Icon(Icons.arrow_forward_ios),
//                 onTap: () {
//                   // Logika ganti password di sini (jika diperlukan)
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Ganti dari Kamera
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.black,
//                   backgroundColor: Colors.grey[300],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   elevation: 0,
//                 ),
//                 onPressed: () => _pickImage(ImageSource.camera),
//                 child: const Text("Ganti Foto Kamera"),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Ganti dari Galeri
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.black,
//                   backgroundColor: Colors.grey[300],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   elevation: 0,
//                 ),
//                 onPressed: () => _pickImage(ImageSource.gallery),
//                 child: const Text("Ganti Foto Galeri"),
//               ),
//             ),
//             const Spacer(),

//             // Tombol Logout
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF8B0000),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   // Tambahkan logika logout di sini
//                 },
//                 child: const Text("Logout"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
