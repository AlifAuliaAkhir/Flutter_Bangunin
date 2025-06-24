import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailAnggaranScreen extends StatefulWidget {
  final int proyekId;
  final String namaProyek;

  const DetailAnggaranScreen({
    super.key,
    required this.proyekId,
    required this.namaProyek,
  });

  @override
  State<DetailAnggaranScreen> createState() => _DetailAnggaranScreenState();
}

class _DetailAnggaranScreenState extends State<DetailAnggaranScreen> {
  List<dynamic> produkList = [];
  List<dynamic> semuaProduk = [];
  bool isLoading = true;
  final baseUrl = dotenv.env['API_URL'];

  @override
  void initState() {
    super.initState();
    fetchProduk();
    fetchSemuaProduk();
  }

  Future<void> fetchProduk() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/proyek'));
      if (response.statusCode == 200) {
        final List proyekData = jsonDecode(response.body);
        final proyek = proyekData.firstWhere(
          (p) => p['id'] == widget.proyekId,
          orElse: () => null,
        );
        if (proyek != null) {
          setState(() {
            produkList = proyek['proyekProducts'];
            isLoading = false;
          });
        }
      } else {
        throw Exception("Gagal memuat proyek. Kode: ${response.statusCode}");
      }
    } catch (e) {
      print('Gagal memuat data produk proyek: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchSemuaProduk() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/product'));
      if (response.statusCode == 200) {
        setState(() {
          semuaProduk = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Gagal ambil data produk: $e");
    }
  }

  Future<void> hapusProduk(int productId) async {
    await http.post(
      Uri.parse('$baseUrl/api/proyek/${widget.proyekId}/add-product'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productId': productId,
        'jumlah': -9999999,
      }),
    );
    fetchProduk();
  }

  void showEditJumlahDialog(Map<String, dynamic> produk) {
    TextEditingController jumlahController =
        TextEditingController(text: produk['jumlah'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Jumlah'),
        content: TextField(
          controller: jumlahController,
          decoration: const InputDecoration(labelText: 'Jumlah'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final jumlahBaru = int.tryParse(jumlahController.text);
              if (jumlahBaru != null && jumlahBaru > 0) {
                await http.post(
                  Uri.parse('$baseUrl/api/proyek/${widget.proyekId}/add-product'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'productId': produk['productId'],
                    'jumlah': jumlahBaru - produk['jumlah'],
                  }),
                );
                Navigator.pop(context);
                fetchProduk();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jumlah tidak valid')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void showTambahProdukDialog() {
    int? selectedProductId;
    TextEditingController jumlahController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Tambah Produk'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedProductId,
                  items: semuaProduk.map<DropdownMenuItem<int>>((produk) {
                    return DropdownMenuItem<int>(
                      value: produk['id_Product'],
                      child: Text(produk['nama_Product'] ?? 'Tanpa Nama'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setStateDialog(() {
                      selectedProductId = val;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Pilih Produk'),
                ),
                TextField(
                  controller: jumlahController,
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final id = selectedProductId;
                  final jumlah = int.tryParse(jumlahController.text);
                  if (id != null && jumlah != null && jumlah > 0) {
                    await http.post(
                      Uri.parse('$baseUrl/api/proyek/${widget.proyekId}/add-product'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'productId': id,
                        'jumlah': jumlah,
                      }),
                    );
                    Navigator.pop(context);
                    fetchProduk();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pilih produk dan masukkan jumlah valid."),
                      ),
                    );
                  }
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
        );
      },
    );
  }

  double getTotalBiaya() {
    return produkList.fold(0.0, (sum, item) {
      final jumlah = item['jumlah'] ?? 0;
      final harga = item['harga'] ?? 0;
      return sum + (jumlah * harga);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Detail: ${widget.namaProyek}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showTambahProdukDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: produkList.isEmpty
                      ? const Center(child: Text('Belum ada produk'))
                      : ListView.builder(
                          itemCount: produkList.length,
                          itemBuilder: (context, index) {
                            final produk = produkList[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(produk['namaProduk'] ?? 'Tanpa Nama'),
                                subtitle: Text(
                                  'ID: ${produk['productId']} | '
                                  'Jumlah: ${produk['jumlah']} ${produk['satuanBarang'] ?? ''} | '
                                  'Harga: Rp${produk['harga']}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => showEditJumlahDialog(produk),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => hapusProduk(produk['productId']),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  color: Colors.amber.shade200,
                  child: Text(
                    'Total Biaya: Rp${getTotalBiaya().toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
    );
  }
}
