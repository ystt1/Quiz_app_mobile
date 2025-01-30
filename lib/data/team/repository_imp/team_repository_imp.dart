import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/team/model/team_model.dart';
import 'package:quiz_app/data/team/model/team_payload_model.dart';
import 'package:quiz_app/data/team/service/team_service.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/service_locator.dart';

import '../../../domain/team/repository/team_repository.dart';

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
  Future<Either> getListTeam() async {
    try {
      final response = await sl<TeamService>().getListTeamService();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<TeamModel>).map((team)=>(team as TeamModel).toEntity()).toList();
        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getTeamDetail() {
    // TODO: implement getTeamDetail
    throw UnimplementedError();
  }

  @override
  Future<Either> kickParticipant() {
    // TODO: implement kickParticipant
    throw UnimplementedError();
  }

  @override
  Future<Either> deleteRequestJoinTeam(String teamId) async {
    return await sl<TeamService>().deleteRequestJoinTeamService(teamId);
  }

}