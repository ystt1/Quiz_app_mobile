import 'package:quiz_app/domain/team/entity/team_entity.dart';

abstract class GetTeamDetailState{
}

class GetTeamDetailLoading extends GetTeamDetailState{}

class GetTeamDetailSuccess extends GetTeamDetailState{
  final TeamEntity team;

  GetTeamDetailSuccess({required this.team});
}

class GetTeamDetailFailure extends GetTeamDetailState{
  final String error;

  GetTeamDetailFailure({required this.error});
}