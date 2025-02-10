import 'package:quiz_app/data/quiz/models/user_score_model.dart';
import 'package:quiz_app/domain/quiz/entity/leader_board_entity.dart';

import '../../user/model/simple_user_model.dart';

class LeaderBoardModel {
  final List<UserScoreModel> boardData;
  final UserScoreModel myData;

  LeaderBoardModel({required this.boardData, required this.myData});

  factory LeaderBoardModel.fromMap(Map<String, dynamic> map) {

    return LeaderBoardModel(
      boardData: (map['leaderBoard'] as List<dynamic>?)
              ?.map((e) => UserScoreModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      myData: map['myData'] != null
          ? UserScoreModel.fromMap(map['myData'] as Map<String, dynamic>)
          : UserScoreModel(
              rank: 0,
              completeTime: 0,
              attemptTime: 0,
              score: 0,
              user:
                  SimpleUserModel(id: '', email: '', avatar: '')),
    );
  }
}

extension LeaderBoardModelToEntity on LeaderBoardModel {
  LeaderBoardEntity toEntity() {
    return LeaderBoardEntity(
        boardData: boardData.map((e) => e.toEntity()).toList(),
        myData: myData.toEntity());
  }
}
