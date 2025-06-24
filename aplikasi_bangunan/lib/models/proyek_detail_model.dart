import 'proyek_product_model.dart';

class ProyekDetailModel {
  final int id;
  final String nama;
  final bool isSelesai;
  final List<ProyekProductModel> proyekProducts;

  ProyekDetailModel({
    required this.id,
    required this.nama,
    required this.isSelesai,
    required this.proyekProducts,
  });

  factory ProyekDetailModel.fromJson(Map<String, dynamic> json) {
    return ProyekDetailModel(
      id: json['id'],
      nama: json['nama'],
      isSelesai: json['isSelesai'],
      proyekProducts: (json['proyekProducts'] as List)
          .map((e) => ProyekProductModel.fromJson(e))
          .toList(),
    );
  }
}
