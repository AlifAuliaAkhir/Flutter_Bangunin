import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void handleRegister(BuildContext context) async {
    final nama = namaController.text.trim();
    final password = passController.text;

    if (nama.isEmpty || password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nama wajib diisi & password minimal 8 karakter")));
      return;
    }

    final res = await UserService.register(nama, password);

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registrasi berhasil")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
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
              const Text("Daftar", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Please fill the details and create account"),
              const SizedBox(height: 20),
              TextField(controller: namaController, decoration: InputDecoration(labelText: "Nama")),
              TextField(controller: passController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
              const Align(alignment: Alignment.centerLeft, child: Text("Password must be 8 character")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => handleRegister(context),
                child: Text("Sign Up"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              TextButton(
                child: const Text("Already have an account? Login"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
