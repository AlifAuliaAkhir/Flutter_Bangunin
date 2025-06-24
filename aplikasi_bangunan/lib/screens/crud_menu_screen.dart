import 'package:flutter/material.dart';
import 'package:aplikasi_bangunan/screens/product/daftar_product_screen.dart';
import 'package:aplikasi_bangunan/screens/toko/daftar_toko_screen.dart';

class CrudMenuScreen extends StatelessWidget {
  const CrudMenuScreen({super.key});

  void navigateProduk(BuildContext context, String label) {
    switch (label) {
      case 'Daftar Produk':
        Navigator.push(context, MaterialPageRoute(builder: (_) => DaftarProdukScreen()));
        break;
    }
  }

  void navigateToko(BuildContext context, String label) {
    switch (label) {
      case 'Daftar Toko':
        Navigator.push(context, MaterialPageRoute(builder: (_) => DaftarTokoScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget section(String title, List<String> buttons, void Function(String) onTap) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: buttons
                  .map((label) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () => onTap(label),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(label, style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: const Text('Tambah Data', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            section('Data Produk', [
              'Daftar Produk',
            ], (label) => navigateProduk(context, label)),
            section('Data Toko Bangunan', [
              'Daftar Toko',
            ], (label) => navigateToko(context, label)),
          ],
        ),
      ),
    );
  }
}
