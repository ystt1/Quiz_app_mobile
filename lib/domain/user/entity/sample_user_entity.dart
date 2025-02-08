class SimpleUserEntity{
  final String id;
  final String email;
  final String avatar;

  SimpleUserEntity({required this.id, required this.email, required this.avatar});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'avatar': this.avatar,
    };
  }

  factory SimpleUserEntity.fromMap(Map<String, dynamic> map) {
    return SimpleUserEntity(
      id: map['_id'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
    );
  }
}