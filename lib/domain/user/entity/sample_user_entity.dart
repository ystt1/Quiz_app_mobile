class SimpleUserEntity{
  final String id;
  final String email;
  final String avatar;
  final String friendshipStatus;
  SimpleUserEntity({required this.id, required this.email, required this.avatar, required this.friendshipStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'avatar': this.avatar,
    };
  }


}