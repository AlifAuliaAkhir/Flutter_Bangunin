import 'package:flutter/material.dart';
import 'package:aplikasi_bangunan/services/product_service.dart';
class HapusProdukScreen extends StatefulWidget {
  @override
  _HapusProdukScreenState createState() => _HapusProdukScreenState();
}

class _HapusProdukScreenState extends State<HapusProdukScreen> {
  final _idController = TextEditingController();

  void _hapus() async {
    try {
      final id = int.parse(_idController.text);
      await ProductService.deleteProduct(id);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal hapus produk')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hapus Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: InputDecoration(labelText: 'ID Produk'), keyboardType: TextInputType.number),
            ElevatedButton(onPressed: _hapus, child: Text('Hapus')),
          ],
        ),
      ),
    );
  }
}
