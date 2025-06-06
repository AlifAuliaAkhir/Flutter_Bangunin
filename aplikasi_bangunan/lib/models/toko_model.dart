class Toko {
  final int idToko;
  final String namaToko;
  final double latitude;
  final double longitude;

  Toko({
    required this.idToko,
    required this.namaToko,
    required this.latitude,
    required this.longitude,
  });

  factory Toko.fromJson(Map<String, dynamic> json) {
    print("DEBUG JSON: $json");
    return Toko(
      idToko: json['idToko'] ?? 0,
      namaToko: (json['namaToko'] ?? '').toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idToko': idToko,
      'namaToko': namaToko,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
