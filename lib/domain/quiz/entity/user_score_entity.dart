


import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class UserScoreEntity {
  final int rank;
  final int completeTime;
  final int attemptTime;
  final int score;
  final SimpleUserEntity user;

  UserScoreEntity(
      {required this.rank, required this.completeTime, required this.attemptTime, required this.score, required this.user});

  Map<String, dynamic> toMap() {
    return {
      'rank': this.rank,
      'completeTime': this.completeTime,
      'attemptTime': this.attemptTime,
      'score': this.score,
      'user': this.user,
    };
  }

}