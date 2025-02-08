class UserEntity{
  final String id;
  final String userName;
  final String avatar;
  final String email;
  final String createdAt;
  final int friendCount;
  final int totalScore;
  final int quizCount;
  final int questionCount;
  final String friendshipStatus;


  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userName': this.userName,
      'avatar': this.avatar,
      'email': this.email,
      'createdAt': this.createdAt,
    };
  }


  const UserEntity({
    required this.id,
    required this.userName,
    required this.avatar,
    required this.email,
    required this.createdAt,
    required this.friendCount,
    required this.totalScore,
    required this.quizCount,
    required this.questionCount,
    required this.friendshipStatus,
  });
}

