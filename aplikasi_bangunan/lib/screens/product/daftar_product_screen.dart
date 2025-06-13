import 'package:flutter/material.dart';
import 'package:aplikasi_bangunan/models/product_model.dart';
import 'package:aplikasi_bangunan/services/product_service.dart';

class DaftarProdukScreen extends StatefulWidget {
  @override
  _DaftarProdukScreenState createState() => _DaftarProdukScreenState();
}

class _DaftarProdukScreenState extends State<DaftarProdukScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = ProductService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Produk')),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // ✅ Interpolasi diperbaiki
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                title: Text(p.namaProduct),
                subtitle: Text("Harga: ${p.harga}, Satuan: ${p.satuanBarang}"), // ✅ Interpolasi benar
              );
            },
          );
        },
      ),
    );
  }
}
