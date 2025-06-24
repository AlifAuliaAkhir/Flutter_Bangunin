class RegisterModel {
  final String nama;
  final String password;
  final String role;

  RegisterModel({
    required this.nama,
    required this.password,
    this.role = "User",
  });

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "password": password,
        "role": role,
      };
}
