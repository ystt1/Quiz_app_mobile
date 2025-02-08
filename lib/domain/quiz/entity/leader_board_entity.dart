

import 'package:quiz_app/domain/quiz/entity/user_score_entity.dart';

class LeaderBoardEntity{
 final List<UserScoreEntity> boardData;
 final UserScoreEntity myData;

  LeaderBoardEntity({required this.boardData, required this.myData});
}