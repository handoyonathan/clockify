class User {
  final String token, id, email, password;

  User({
    required this.id,
    required this.token,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      id: json['user']['id'].toString(),
      email: json['user']['email'],
      password: json['user']['password'],
    );
  }
}