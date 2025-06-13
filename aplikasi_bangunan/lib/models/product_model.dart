class Product {
  final int idProduct;
  final String namaProduct;
  final int harga;
  final String satuanBarang;

  Product({
    required this.idProduct,
    required this.namaProduct,
    required this.harga,
    required this.satuanBarang,
  });

  // Factory untuk parsing dari JSON ASP.NET
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        idProduct: json['id_Product'] ?? 0,
        namaProduct: json['nama_Product'] ?? '',
        harga: json['harga'] ?? 0,
        satuanBarang: json['satuanBarang'] ?? '',
      );

  // Untuk POST dan PUT: kirim sesuai struktur DTO ASP.NET
  Map<String, dynamic> toJson() => {
        'nama_Product': namaProduct,
        'harga': harga,
        'satuanBarang': satuanBarang,
      };
}
