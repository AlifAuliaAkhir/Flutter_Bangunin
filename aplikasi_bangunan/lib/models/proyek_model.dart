
enum SatuanBarang { Pcs, Kg, Liter }

class Proyek {
  final int id;
  final String nama;
  final bool isSelesai;
  final List<ProyekProduct> proyekProducts;

  Proyek({
    required this.id,
    required this.nama,
    required this.isSelesai,
    required this.proyekProducts,
  });

  factory Proyek.fromJson(Map<String, dynamic> json) {
    return Proyek(
      id: json['id'],
      nama: json['nama'],
      isSelesai: json['isSelesai'],
      proyekProducts: (json['proyekProducts'] as List)
          .map((e) => ProyekProduct.fromJson(e))
          .toList(),
    );
  }
}

class ProyekProduct {
  final int productId;
  final String namaProduk;
  final int harga;
  final int jumlah;
  final SatuanBarang satuanBarang;

  ProyekProduct({
    required this.productId,
    required this.namaProduk,
    required this.harga,
    required this.jumlah,
    required this.satuanBarang,
  });

  factory ProyekProduct.fromJson(Map<String, dynamic> json) {
    return ProyekProduct(
      productId: json['productId'],
      namaProduk: json['namaProduk'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      satuanBarang: SatuanBarang.values.firstWhere(
        (e) => e.name.toLowerCase() == json['satuanBarang'].toString().toLowerCase(),
        orElse: () => SatuanBarang.Pcs,
      ),
    );
  }
}