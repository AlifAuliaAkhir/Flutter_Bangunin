class ResetPasswordModel {
  final String nama;
  final String passwordLama;
  final String passwordBaru;

  ResetPasswordModel({
    required this.nama,
    required this.passwordLama,
    required this.passwordBaru,
  });

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "passwordLama": passwordLama,
        "passwordBaru": passwordBaru,
      };
}
