import 'package:quiz_app/data/quiz/models/user_score_model.dart';
import 'package:quiz_app/domain/quiz/entity/leader_board_entity.dart';

class LeaderBoardModel {
  final List<UserScoreModel> boardData;
  final UserScoreModel myData;

  LeaderBoardModel({required this.boardData, required this.myData});

  factory LeaderBoardModel.fromMap(Map<String, dynamic> map) {
    return LeaderBoardModel(
      boardData: (map['leaderBoard'] as List<dynamic>)
          .map((e) => UserScoreModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      myData: UserScoreModel.fromMap(map['myData'] as Map<String, dynamic>),
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
