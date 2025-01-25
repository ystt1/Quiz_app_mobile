class LoginPayLoad{
  final String username;
  final String password;

  LoginPayLoad({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'password': this.password,
    };
  }

  factory LoginPayLoad.fromMap(Map<String, dynamic> map) {
    return LoginPayLoad(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }
}