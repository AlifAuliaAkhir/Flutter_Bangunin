import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();

  void handleResetPassword(BuildContext context) async {
    final nama = namaController.text.trim();
    final oldPass = oldPassController.text;
    final newPass = newPassController.text;

    if (nama.isEmpty || oldPass.isEmpty || newPass.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Isi semua data. Password baru minimal 8 karakter")));
      return;
    }

    final res = await UserService.resetPassword(nama, oldPass, newPass);

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password berhasil diubah")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: ${res.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Lupa Password", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Enter your email account to reset your password"),
              const SizedBox(height: 20),
              TextField(controller: namaController, decoration: InputDecoration(labelText: "Email")),
              TextField(controller: oldPassController, obscureText: true, decoration: InputDecoration(labelText: "Password Lama")),
              TextField(controller: newPassController, obscureText: true, decoration: InputDecoration(labelText: "Password Baru")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => handleResetPassword(context),
                child: Text("Reset Password"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
