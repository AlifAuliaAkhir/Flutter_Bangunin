import 'package:flutter/material.dart';
import 'package:aplikasi_bangunan/models/product_model.dart';
import 'package:aplikasi_bangunan/services/product_service.dart';

class DaftarProdukScreen extends StatefulWidget {
  const DaftarProdukScreen({super.key});

  @override
  State<DaftarProdukScreen> createState() => _DaftarProdukScreenState();
}

class _DaftarProdukScreenState extends State<DaftarProdukScreen> {
  List<Product> _produkList = [];
  List<Product> _filteredProduk = [];
  final TextEditingController _cariController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  void _loadProduk() async {
    final data = await ProductService.fetchProducts();
    setState(() {
      _produkList = data;
      _filteredProduk = data;
    });
  }

  void _filterById(String query) {
    final id = int.tryParse(query);
    if (id != null) {
      final result = _produkList.where((p) => p.idProduct == id).toList();
      setState(() => _filteredProduk = result);
    } else {
      setState(() => _filteredProduk = _produkList);
    }
  }

  void _showForm({Product? product}) {
    final isEdit = product != null;
    final TextEditingController namaController =
        TextEditingController(text: product?.namaProduct ?? '');
    final TextEditingController hargaController =
        TextEditingController(text: product?.harga.toString() ?? '');
    final TextEditingController satuanController =
        TextEditingController(text: product?.satuanBarang ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: namaController, decoration: InputDecoration(labelText: 'Nama Produk')),
              TextField(controller: hargaController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
              TextField(controller: satuanController, decoration: InputDecoration(labelText: 'Satuan (Pcs, Kg, Meter, Liter, Pack)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final newProduct = Product(
                idProduct: product?.idProduct ?? 0,
                namaProduct: namaController.text,
                harga: int.parse(hargaController.text),
                satuanBarang: satuanController.text,
              );
              if (isEdit) {
                await ProductService.updateProduct(newProduct.idProduct, newProduct);
              } else {
                await ProductService.addProduct(newProduct);
              }
              Navigator.pop(context);
              _loadProduk();
            },
            child: Text(isEdit ? 'Update' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _hapusProduk(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Tidak')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Ya')),
        ],
      ),
    );
    if (confirm == true) {
      await ProductService.deleteProduct(id);
      _loadProduk();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 211, 165, 14),
        title: const Text('Daftar Produk', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _showForm(),
            icon: Icon(Icons.add, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _cariController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cari ID Produk',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _filterById,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProduk.length,
                itemBuilder: (context, index) {
                  final p = _filteredProduk[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text('${p.idProduct} - ${p.namaProduct}'),
                      subtitle: Text('Harga: ${p.harga}, Satuan: ${p.satuanBarang}'),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showForm(product: p),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _hapusProduk(p.idProduct),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
