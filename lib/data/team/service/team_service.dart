import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/api_service.dart';
import 'package:quiz_app/data/team/model/team_model.dart';
import 'package:quiz_app/data/team/model/team_payload_model.dart';
import 'package:quiz_app/service_locator.dart';

abstract class TeamService{
  Future<Either> acceptRequestService();
  Future<Either> addRequestJoinTeamService(String teamId);
  Future<Either> addTeamService(TeamPayloadModel team);
  Future<Either> editTeamDetailService();
  Future<Either> getListTeamService();
  Future<Either> getTeamDetailService();
  Future<Either> kickParticipantService();
  Future<Either> deleteRequestJoinTeamService(String teamId);
}

class TeamServiceImp extends TeamService {
  @override
  Future<Either> acceptRequestService() {
    // TODO: implement acceptRequestService
    throw UnimplementedError();
  }

  @override
  Future<Either> addRequestJoinTeamService(String teamId) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.post('http://localhost:5000/api/request-join', {'idTeam':teamId});

      if(response.statusCode==200)
      {
        return Right((jsonDecode(response.body)));
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addTeamService(TeamPayloadModel team) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.post('http://localhost:5000/api/team', team.toMap());

      if(response.statusCode==200)
      {
        return Right((jsonDecode(response.body)));
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> editTeamDetailService() {
    // TODO: implement editTeamDetailService
    throw UnimplementedError();
  }

  @override
  Future<Either> getListTeamService() async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get('http://localhost:5000/api/team');

      if(response.statusCode==200)
      {
        List<dynamic> data=(jsonDecode(response.body)["data"]);
        List<TeamModel> teams=data.map((e)=>TeamModel.fromMap(e)).toList();
        return Right(teams);
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getTeamDetailService() {
    // TODO: implement getTeamDetailService
    throw UnimplementedError();
  }

  @override
  Future<Either> kickParticipantService() {
    // TODO: implement kickParticipantService
    throw UnimplementedError();
  }

  @override
  Future<Either> deleteRequestJoinTeamService(String teamId) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.delete('http://localhost:5000/api/request-join', {'idTeam':teamId});

      if(response.statusCode==200)
      {
        return Right((jsonDecode(response.body)));
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

}