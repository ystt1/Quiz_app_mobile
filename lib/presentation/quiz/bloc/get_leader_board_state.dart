import 'package:quiz_app/domain/quiz/entity/leader_board_entity.dart';

abstract class GetLeaderBoardState{}

class GetLeaderBoardLoading extends GetLeaderBoardState{}


class GetLeaderBoardSuccess extends GetLeaderBoardState{
  final LeaderBoardEntity leaderBoard;
  GetLeaderBoardSuccess({required this.leaderBoard});
}


class GetLeaderBoardFailure extends GetLeaderBoardState{
  final String error;
  GetLeaderBoardFailure({required this.error});
}