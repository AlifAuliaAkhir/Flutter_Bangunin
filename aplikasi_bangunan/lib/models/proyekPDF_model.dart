class Proyek {
  final int id;
  final String nama;
  final bool isSelesai; 
  final List<dynamic> produkList;

  Proyek({
    required this.id,
    required this.nama,
    required this.isSelesai,
    required this.produkList,
  });

  factory Proyek.fromJson(Map<String, dynamic> json) {
    return Proyek(
      id: json['id'],
      nama: json['nama'],
      isSelesai: json['isSelesai'] ?? false, 
      produkList: json['proyekProducts'] ?? [],
    );
  }
}
