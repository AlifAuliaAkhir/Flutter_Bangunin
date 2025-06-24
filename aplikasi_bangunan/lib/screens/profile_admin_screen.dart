import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restart_app/restart_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileAdminScreen extends StatefulWidget {
  const ProfileAdminScreen({super.key});

  @override
  State<ProfileAdminScreen> createState() => _ProfileAdminScreenState();
}

class _ProfileAdminScreenState extends State<ProfileAdminScreen> {
  File? _profileImage;
  bool showGantiPassword = false;

  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedProfileImage();
  }

  Future<void> _loadSavedProfileImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile.jpg');
    if (await file.exists()) {
      setState(() {
        _profileImage = file;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      final dir = await getApplicationDocumentsDirectory();
      await File(picked.path).copy('${dir.path}/profile.jpg');
      Restart.restartApp();
    }
  }

  Future<void> _logout() async {
    Restart.restartApp();
  }

  Future<void> _gantiPasswordAdmin() async {
    final newPass = _newPasswordController.text.trim();

    if (newPass.isEmpty || newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 6 karakter.")),
      );
      return;
    }

    final res = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/api/auth/ganti-password'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": "admin",
        "password": newPass,
      }),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res.statusCode == 200 ? "Password berhasil diganti" : "Gagal: ${res.body}")),
    );

    if (res.statusCode == 200) {
      _newPasswordController.clear();
      setState(() => showGantiPassword = false);
    }
  }

  Widget _buildFullWidthButton({
    required String label,
    required VoidCallback onPressed,
    Color? color,
    Color? textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.teal,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD54F),
        title: const Center(child: Text("Profile", style: TextStyle(color: Colors.white))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null ? const Icon(Icons.person, size: 40) : null,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Welcome, Admin!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),

            _buildFullWidthButton(
              label: showGantiPassword ? "Tutup Form Ganti Password" : "Ganti Password",
              onPressed: () => setState(() => showGantiPassword = !showGantiPassword),
              color: Colors.teal.shade700,
              textColor: const Color.fromARGB(221, 255, 255, 255),
            ),

            if (showGantiPassword) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password Baru"),
              ),
              const SizedBox(height: 16),
              _buildFullWidthButton(
                label: "Simpan Password",
                onPressed: _gantiPasswordAdmin,
              ),
              const SizedBox(height: 20),
            ],

            _buildFullWidthButton(
              label: "Ganti Foto Kamera",
              onPressed: () => _pickImage(ImageSource.camera),
              color: Colors.teal.shade700,
            ),
            const SizedBox(height: 10),
            _buildFullWidthButton(
              label: "Ganti Foto Galeri",
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Colors.teal.shade700,
            ),

            const Spacer(),

            _buildFullWidthButton(
              label: "Logout",
              onPressed: _logout,
              color: const Color(0xFF8B0000),
            ),
          ],
        ),
      ),
    );
  }
}
