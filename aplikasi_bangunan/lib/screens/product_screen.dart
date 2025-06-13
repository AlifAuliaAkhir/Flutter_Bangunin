import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService.fetchProducts();
  }

  void _refresh() {
    setState(() {
      _productFuture = ProductService.fetchProducts();
    });
  }

  void _showAddDialog() {
    final _namaController = TextEditingController();
    final _hargaController = TextEditingController();
    final _satuanController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Tambah Produk"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _namaController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: _hargaController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            TextField(controller: _satuanController, decoration: InputDecoration(labelText: 'Satuan')),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Simpan"),
            onPressed: () async {
              final product = Product(
                idProduct: 0,
                namaProduct: _namaController.text,
                harga: int.tryParse(_hargaController.text) ?? 0,
                satuanBarang: _satuanController.text,
              );
              await ProductService.addProduct(product);
              Navigator.pop(context);
              _refresh();
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Product product) {
    final _namaController = TextEditingController(text: product.namaProduct);
    final _hargaController = TextEditingController(text: product.harga.toString());
    final _satuanController = TextEditingController(text: product.satuanBarang);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Produk"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _namaController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: _hargaController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            TextField(controller: _satuanController, decoration: InputDecoration(labelText: 'Satuan')),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Update"),
            onPressed: () async {
              final updatedProduct = Product(
                idProduct: product.idProduct,
                namaProduct: _namaController.text,
                harga: int.tryParse(_hargaController.text) ?? 0,
                satuanBarang: _satuanController.text,
              );
              await ProductService.updateProduct(product.idProduct, updatedProduct);
              Navigator.pop(context);
              _refresh();
            },
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    final _idController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Cari Produk by ID"),
        content: TextField(
          controller: _idController,
          decoration: InputDecoration(labelText: 'ID Produk'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            child: Text("Cari"),
            onPressed: () async {
              try {
                final product = await ProductService.fetchProductById(int.parse(_idController.text));
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Detail Produk"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: ${product.idProduct}"),
                        Text("Nama: ${product.namaProduct}"),
                        Text("Harga: ${product.harga}"),
                        Text("Satuan: ${product.satuanBarang}"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text("Tutup"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produk tidak ditemukan')));
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data'));
          }

          final products = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nama')),
                DataColumn(label: Text('Harga')),
                DataColumn(label: Text('Satuan')),
                DataColumn(label: Text('Aksi')),
              ],
              rows: products.map((product) {
                return DataRow(cells: [
                  DataCell(Text(product.idProduct.toString())),
                  DataCell(Text(product.namaProduct)),
                  DataCell(Text(product.harga.toString())),
                  DataCell(Text(product.satuanBarang)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog(product),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await ProductService.deleteProduct(product.idProduct);
                          _refresh();
                        },
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
