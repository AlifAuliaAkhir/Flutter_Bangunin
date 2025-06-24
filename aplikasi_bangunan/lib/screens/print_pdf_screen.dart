import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:aplikasi_bangunan/models/proyekPDF_model.dart';
import 'package:aplikasi_bangunan/services/proyekPDF_service.dart';
import 'package:aplikasi_bangunan/screens/home_user_screen.dart';

class PrintPDFScreen extends StatefulWidget {
  const PrintPDFScreen({super.key});

  @override
  State<PrintPDFScreen> createState() => _PrintPDFScreenState();
}

class _PrintPDFScreenState extends State<PrintPDFScreen> {
  late Future<List<Proyek>> proyekList;

  @override
  void initState() {
    super.initState();
    proyekList = ProyekService.getProyekSelesai();
  }

  Future<void> _printPDF(int id) async {
    try {
      final bytes = await ProyekService.fetchPDF(id);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/proyek_$id.pdf');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mencetak PDF: $e')));
    }
  }

  double hitungTotal(List<dynamic> products) {
    return products.fold(0.0, (total, item) {
      final harga = item['harga'] ?? 0;
      final jumlah = item['jumlah'] ?? 0;
      return total + (harga * jumlah);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4D35E),
        title: const Text(
          "Cetak Dokumen",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeUserScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Unduhan Project",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Proyek>>(
                future: proyekList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada proyek yang selesai.'),
                    );
                  }

                  final proyekSelesai = snapshot.data!;
                  return ListView.separated(
                    itemCount: proyekSelesai.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final proyek = proyekSelesai[index];
                      final totalHarga = hitungTotal(proyek.produkList);

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            proyek.nama,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text('Total: Rp${totalHarga.toStringAsFixed(0)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.download_rounded),
                            onPressed: () => _printPDF(proyek.id),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
