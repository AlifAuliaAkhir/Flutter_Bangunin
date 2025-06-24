class ProyekProductModel {
  final int productId;
  final String namaProduk;
  final int harga;
  final int jumlah;
  final String satuanBarang;

  ProyekProductModel({
    required this.productId,
    required this.namaProduk,
    required this.harga,
    required this.jumlah,
    required this.satuanBarang,
  });

  factory ProyekProductModel.fromJson(Map<String, dynamic> json) {
    return ProyekProductModel(
      productId: json['productId'],
      namaProduk: json['namaProduk'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      satuanBarang: json['satuanBarang'],
    );
  }
}
