import 'package:quiz_app/domain/user/entity/user_entity.dart';

class UserModel {
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String? ?? '',
      userName: map['username'] as String? ?? '',
      avatar: map.containsKey('avatar') && map['avatar'] != null
          ? map['avatar'] as String
          : "",
      email: map['email'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? DateTime.now().toString(),
      friendCount: map['friendCount'] as int? ?? 0,
      totalScore: map['totalScore'] as int? ?? 0,
      quizCount: map['quizCount'] as int? ?? 0,
      questionCount: map['questionCount'] as int? ?? 0,
      friendshipStatus: map['friendshipStatus'] as String? ?? '',
    );
  }

  const UserModel({
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

extension UserModelToEntity on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        id: id,
        userName: userName,
        avatar: avatar,
        email: email,
        createdAt: createdAt,
        friendCount: friendCount,
        totalScore: totalScore,
        quizCount: quizCount,
        questionCount: questionCount,
        friendshipStatus: friendshipStatus);
  }
}
