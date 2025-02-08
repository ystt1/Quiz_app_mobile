import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/team/model/join_request_model.dart';
import 'package:quiz_app/data/post/models/post_model.dart';
import 'package:quiz_app/data/team/model/kick_team_payload_model.dart';
import 'package:quiz_app/data/team/model/put_team_quiz_payload.dart';
import 'package:quiz_app/data/team/model/team_model.dart';
import 'package:quiz_app/data/team/model/team_payload_model.dart';
import 'package:quiz_app/data/team/service/team_service.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/domain/team/usecase/kick_participant_usecase.dart';
import 'package:quiz_app/service_locator.dart';

import '../../../domain/team/repository/team_repository.dart';
import '../model/request_payload_model.dart';

class TeamRepositoryImp extends TeamRepository {
  @override
  Future<Either> acceptRequest() {
    // TODO: implement acceptRequest
    throw UnimplementedError();
  }

  @override
  Future<Either> addRequestJoinTeam(String teamId) async {
    return await sl<TeamService>().addRequestJoinTeamService(teamId);
  }

  @override
  Future<Either> addTeam(TeamPayloadModel team) async {
    return await sl<TeamService>().addTeamService(team);
  }

  @override
  Future<Either> editTeamDetail() {
    // TODO: implement editTeamDetail
    throw UnimplementedError();
  }

  @override
  Future<Either> getListTeam(String params) async {
    try {
      final response = await sl<TeamService>().getListTeamService(params);
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<TeamModel>)
            .map((team) => (team as TeamModel).toEntity())
            .toList();
        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getTeamDetail(String teamId) async {
    try {
      final response = await sl<TeamService>().getTeamDetailService(teamId);

      return response.fold((error) => Left(error), (data)=>Right((data as TeamModel).toEntity()));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> kickParticipant(KickTeamPayLoadModel kickUser) async {
    return await sl<TeamService>().kickParticipantService(kickUser);
  }

  @override
  Future<Either> deleteRequestJoinTeam(String teamId) async {
    return await sl<TeamService>().deleteRequestJoinTeamService(teamId);
  }

  @override
  Future<Either> getRequest(String teamId) async {
    try {
      final returnedData = await sl<TeamService>().getRequest(teamId);
      return returnedData.fold((error) => Left(error), (data) {
        return Right((data as List<JoinRequestModel>)
            .map((JoinRequestModel e) => e.toEntity())
            .toList());
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> hostChangeJoinRequest(RequestPayload status) {
    return sl<TeamService>().hostChangeRequest(status);
  }

  @override
  Future<Either> leaveTeam(String teamId) {
    return sl<TeamService>().leaveTeam(teamId);
  }

  @override
  Future<Either> addQuizToTeam(PutTeamQuizPayload teamQuizzes) {
    return sl<TeamService>().addQuizToTeam(teamQuizzes);
  }

  @override
  Future<Either> removeQuizToTeam(PutTeamQuizPayload teamQuizzes) {
    return sl<TeamService>().deleteQuizFromTeam(teamQuizzes);
  }


}
