import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restart_app/restart_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileUserScreen extends StatefulWidget {
  final String namaUser;

  const ProfileUserScreen({super.key, required this.namaUser});

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  File? _profileImage;
  bool showGantiPassword = false;

  final TextEditingController _newPassController = TextEditingController();

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

  Future<void> _gantiPasswordUser() async {
    final newPass = _newPassController.text.trim();

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 6 karakter")),
      );
      return;
    }

    final res = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/api/auth/ganti-password-user'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": widget.namaUser,
        "passwordBaru": newPass,
      }),
    );

    final msg = res.statusCode == 200
        ? "Password berhasil diganti"
        : "Gagal: ${res.body}";

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    if (res.statusCode == 200) {
      _newPassController.clear();
      setState(() => showGantiPassword = false);
    }
  }

  Widget _buildFullWidthButton({
    required String label,
    required VoidCallback onPressed,
    Color color = Colors.teal,
    Color textColor = Colors.white,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
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
        centerTitle: true,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
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
                Expanded(
                  child: Text(
                    "Welcome di Bangun.in!",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            _buildFullWidthButton(
              label: showGantiPassword ? "Tutup Form Ganti Password" : "Ganti Password",
              onPressed: () => setState(() => showGantiPassword = !showGantiPassword),
              color: Colors.teal.shade700,
            ),

            if (showGantiPassword) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _newPassController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password Baru"),
              ),
              const SizedBox(height: 16),
              _buildFullWidthButton(
                label: "Simpan Password",
                onPressed: _gantiPasswordUser,
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
