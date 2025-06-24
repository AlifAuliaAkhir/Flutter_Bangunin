import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    final nama = namaController.text.trim();
    final password = passwordController.text;

    if (nama.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi semua field")),
      );
      return;
    }

    final result = await UserService.login(nama, password);

    if (result.containsKey("token")) {
      final role = result["role"];
      final namaUser = result["nama"];

      // Simpan nama user ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('namaUser', namaUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login berhasil sebagai $role")),
      );

      // Arahkan user ke halaman sesuai role
      Future.delayed(const Duration(milliseconds: 500), () {
        if (role == "Admin") {
          Navigator.pushReplacementNamed(context, '/home-admin');
        } else {
          Navigator.pushReplacementNamed(context, '/home-user');
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: ${result.toString()}")),
      );
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
              const Text("Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Please sign in to continue our app"),
              const SizedBox(height: 20),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: const Text("Forget Password?"),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Sign In"),
              ),
              TextButton(
                child: const Text("Don't have an account? Daftar"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
