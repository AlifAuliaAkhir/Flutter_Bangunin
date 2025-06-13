import 'package:flutter/material.dart';
import 'package:aplikasi_bangunan/models/product_model.dart';
import 'package:aplikasi_bangunan/services/product_service.dart';

class UpdateProdukScreen extends StatefulWidget {
  @override
  _UpdateProdukScreenState createState() => _UpdateProdukScreenState();
}

class _UpdateProdukScreenState extends State<UpdateProdukScreen> {
  final _idController = TextEditingController();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _satuanController = TextEditingController();

  void _update() async {
    try {
      final id = int.parse(_idController.text);
      final updatedProduct = Product(
        idProduct: id,
        namaProduct: _namaController.text,
        harga: int.parse(_hargaController.text),
        satuanBarang: _satuanController.text,
      );
      await ProductService.updateProduct(id, updatedProduct);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal update produk')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: InputDecoration(labelText: 'ID Produk'), keyboardType: TextInputType.number),
            TextField(controller: _namaController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: _hargaController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            TextField(controller: _satuanController, decoration: InputDecoration(labelText: 'Satuan')),
            ElevatedButton(onPressed: _update, child: Text('Update')),
          ],
        ),
      ),
    );
  }
}