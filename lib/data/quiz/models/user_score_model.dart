import 'package:quiz_app/data/user/model/simple_user_model.dart';
import 'package:quiz_app/domain/quiz/entity/leader_board_entity.dart';
import 'package:quiz_app/domain/quiz/entity/user_score_entity.dart';

class UserScoreModel {
  final int rank;
  final int completeTime;
  final int attemptTime;
  final int score;
  final SimpleUserModel user;

  UserScoreModel(
      {required this.rank,
      required this.completeTime,
      required this.attemptTime,
      required this.score,
      required this.user});

  Map<String, dynamic> toMap() {
    return {
      'rank': this.rank,
      'completeTime': this.completeTime,
      'attemptTime': this.attemptTime,
      'score': this.score,
      'user': this.user,
    };
  }

  factory UserScoreModel.fromMap(Map<String, dynamic> map) {
    return UserScoreModel(
      rank: map['rank'] as int,
      completeTime: map['completeTime'] as int,
      attemptTime: map['attempTime'] as int,
      score: map['score'] as int,
      user: SimpleUserModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }
}

extension UserScoreModelToEntity on UserScoreModel {
  UserScoreEntity toEntity() {
    return UserScoreEntity(
        rank: rank,
        completeTime: completeTime,
        attemptTime: attemptTime,
        score: score,
        user: user.toEntity());
  }
}
