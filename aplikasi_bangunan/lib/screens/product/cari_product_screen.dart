import 'package:flutter/material.dart';
import 'package:aplikasi_bangunan/models/product_model.dart';
import 'package:aplikasi_bangunan/services/product_service.dart';

class CariProdukScreen extends StatefulWidget {
  @override
  _CariProdukScreenState createState() => _CariProdukScreenState();
}

class _CariProdukScreenState extends State<CariProdukScreen> {
  final _idController = TextEditingController();
  Product? _product;
  String? _error;

  void _cari() async {
    try {
      final id = int.parse(_idController.text);
      final result = await ProductService.fetchProductById(id);
      setState(() {
        _product = result;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _product = null;
        _error = 'Produk tidak ditemukan';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cari ID Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'ID Produk'),
            ),
            ElevatedButton(onPressed: _cari, child: Text('Cari')),
            SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_product != null)
              Card(
                child: ListTile(
                  title: Text(_product!.namaProduct),
                  subtitle: Text("Harga: ${_product!.harga}, Satuan: ${_product!.satuanBarang}"), // ✅ Interpolasi benar
                ),
              ),
          ],
        ),
      ),
    );
  }
}
