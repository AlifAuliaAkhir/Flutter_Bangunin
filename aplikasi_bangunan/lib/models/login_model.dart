class LoginModel {
  final String nama;
  final String password;

  LoginModel({required this.nama, required this.password});

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "password": password,
      };
}
