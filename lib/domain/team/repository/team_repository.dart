import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/team/model/kick_team_payload_model.dart';
import 'package:quiz_app/data/team/model/put_team_quiz_payload.dart';
import 'package:quiz_app/data/team/model/team_payload_model.dart';

import '../../../data/team/model/request_payload_model.dart';

abstract class TeamRepository{
  Future<Either> acceptRequest();
  Future<Either> addRequestJoinTeam(String teamId);
  Future<Either> addTeam(TeamPayloadModel team);
  Future<Either> editTeamDetail();
  Future<Either> getListTeam(String params);
  Future<Either> getTeamDetail(String teamId);
  Future<Either> kickParticipant(KickTeamPayLoadModel kickUser);
  Future<Either> deleteRequestJoinTeam(String teamId);
  Future<Either> getRequest(String teamId);
  Future<Either> hostChangeJoinRequest(RequestPayload status);
  Future<Either> leaveTeam(String teamId);
  Future<Either> addQuizToTeam(PutTeamQuizPayload teamQuizzes);
  Future<Either> removeQuizToTeam(PutTeamQuizPayload teamQuizzes);
}