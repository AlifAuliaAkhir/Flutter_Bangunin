import 'package:flutter/material.dart';
import 'package:aplikasi_bangunan/models/toko_model.dart';
import 'package:aplikasi_bangunan/services/toko_service.dart';

class DaftarTokoScreen extends StatefulWidget {
  const DaftarTokoScreen({super.key});

  @override
  State<DaftarTokoScreen> createState() => _DaftarTokoScreenState();
}

class _DaftarTokoScreenState extends State<DaftarTokoScreen> {
  List<Toko> _tokoList = [];
  List<Toko> _filteredToko = [];
  final TextEditingController _cariController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToko();
  }

  void _loadToko() async {
    final data = await TokoService.getAll();
    setState(() {
      _tokoList = data;
      _filteredToko = data;
    });
  }

  void _filterById(String query) {
    final id = int.tryParse(query);
    if (id != null) {
      final result = _tokoList.where((t) => t.idToko == id).toList();
      setState(() => _filteredToko = result);
    } else {
      setState(() => _filteredToko = _tokoList);
    }
  }

  void _showForm({Toko? toko}) {
    final isEdit = toko != null;
    final TextEditingController namaController = TextEditingController(text: toko?.namaToko ?? '');
    final TextEditingController latController = TextEditingController(text: toko?.latitude.toString() ?? '');
    final TextEditingController longController = TextEditingController(text: toko?.longitude.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Toko' : 'Tambah Toko'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: namaController, decoration: InputDecoration(labelText: 'Nama Toko')),
              TextField(controller: latController, decoration: InputDecoration(labelText: 'Latitude'), keyboardType: TextInputType.number),
              TextField(controller: longController, decoration: InputDecoration(labelText: 'Longitude'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final newToko = Toko(
                idToko: toko?.idToko ?? 0,
                namaToko: namaController.text,
                latitude: double.tryParse(latController.text) ?? 0.0,
                longitude: double.tryParse(longController.text) ?? 0.0,
              );
              if (isEdit) {
                await TokoService.update(newToko.idToko, newToko);
              } else {
                await TokoService.create(newToko);
              }
              Navigator.pop(context);
              _loadToko();
            },
            child: Text(isEdit ? 'Update' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _hapusToko(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Yakin ingin menghapus toko ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Tidak')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Ya')),
        ],
      ),
    );
    if (confirm == true) {
      await TokoService.delete(id);
      _loadToko();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 200, 197, 6),
        title: const Text('Daftar Toko', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _showForm(),
            icon: Icon(Icons.add, color: Colors.white),
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
                labelText: 'Cari ID Toko',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _filterById,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredToko.length,
                itemBuilder: (context, index) {
                  final t = _filteredToko[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text('${t.idToko} - ${t.namaToko}'),
                      subtitle: Text('Lat: ${t.latitude}, Long: ${t.longitude}'),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showForm(toko: t),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _hapusToko(t.idToko),
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
