import 'package:flutter/material.dart';
import 'package:aplikasi_bangunan/models/product_model.dart';
import 'package:aplikasi_bangunan/services/product_service.dart';

class TambahProdukScreen extends StatefulWidget {
  @override
  _TambahProdukScreenState createState() => _TambahProdukScreenState();
}

class _TambahProdukScreenState extends State<TambahProdukScreen> {
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _satuanController = TextEditingController();

  void _simpan() async {
    try {
      final newProduct = Product(
        idProduct: 0,
        namaProduct: _namaController.text,
        harga: int.parse(_hargaController.text),
        satuanBarang: _satuanController.text,
      );
      await ProductService.addProduct(newProduct);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menambahkan produk')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _namaController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: _hargaController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            TextField(controller: _satuanController, decoration: InputDecoration(labelText: 'Satuan')),
            ElevatedButton(onPressed: _simpan, child: Text('Simpan')),
          ],
        ),
      ),
    );
  }
}