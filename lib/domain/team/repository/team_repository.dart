import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/team/model/team_payload_model.dart';

abstract class TeamRepository{
  Future<Either> acceptRequest();
  Future<Either> addRequestJoinTeam(String teamId);
  Future<Either> addTeam(TeamPayloadModel team);
  Future<Either> editTeamDetail();
  Future<Either> getListTeam();
  Future<Either> getTeamDetail();
  Future<Either> kickParticipant();
  Future<Either> deleteRequestJoinTeam(String teamId);
}