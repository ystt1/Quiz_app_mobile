class RegisterPayload{
  final String useName;
  final String password;
  final String gmail;

  RegisterPayload({required this.useName, required this.password, required this.gmail});

  Map<String, dynamic> toMap() {
    return {
      'usernam': this.useName,
      'password': this.password,
      'email': this.gmail,
    };
  }

  factory RegisterPayload.fromMap(Map<String, dynamic> map) {
    return RegisterPayload(
      useName: map['useName'] as String,
      password: map['password'] as String,
      gmail: map['gmail'] as String,
    );
  }
}