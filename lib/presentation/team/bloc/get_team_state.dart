import 'package:quiz_app/domain/team/entity/team_entity.dart';

abstract class GetTeamState{
}

class GetTeamLoading extends GetTeamState{}

class GetTeamSuccess extends GetTeamState{
  final List<TeamEntity> teams;

  GetTeamSuccess({required this.teams});
}

class GetTeamFailure extends GetTeamState{
  final String error;

  GetTeamFailure({required this.error});
}