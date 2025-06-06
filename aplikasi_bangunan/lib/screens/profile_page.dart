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

//       // buat aplikasi biar auto restart 
//       Restart.restartApp();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profil"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text("Nama: Sandi", style: TextStyle(fontSize: 20)),
//             const SizedBox(height: 5),
//             const Text("Sandi: *****", style: TextStyle(fontSize: 16, color: Colors.grey)),
//             const SizedBox(height: 20),
//             CircleAvatar(
//               radius: 60,
//               backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
//               child: _profileImage == null
//                   ? const Icon(Icons.person, size: 60)
//                   : null,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.camera_alt),
//               label: const Text("Ambil dari Kamera"),
//               onPressed: () => _pickImage(ImageSource.camera),
//             ),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.photo_library),
//               label: const Text("Ambil dari Galeri"),
//               onPressed: () => _pickImage(ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
