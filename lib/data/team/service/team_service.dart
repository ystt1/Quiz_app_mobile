import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/api_service.dart';
import 'package:quiz_app/data/team/model/join_request_model.dart';
import 'package:quiz_app/data/team/model/kick_team_payload_model.dart';
import 'package:quiz_app/data/team/model/put_team_quiz_payload.dart';
import 'package:quiz_app/data/team/model/request_payload_model.dart';
import 'package:quiz_app/data/team/model/team_model.dart';
import 'package:quiz_app/data/team/model/team_payload_model.dart';
import 'package:quiz_app/service_locator.dart';

import 'package:http/http.dart' as http;
import '../../../core/constant/url.dart';

abstract class TeamService {
  Future<Either> acceptRequestService();

  Future<Either> addRequestJoinTeamService(String teamId);

  Future<Either> addTeamService(TeamPayloadModel team);

  Future<Either> editTeamDetailService();

  Future<Either> getListTeamService(String params);

  Future<Either> getTeamDetailService(String teamId);

  Future<Either> kickParticipantService(KickTeamPayLoadModel kickTeam);

  Future<Either> deleteRequestJoinTeamService(String teamId);

  Future<Either> getRequest(String teamId);

  Future<Either> hostChangeRequest(RequestPayload status);

  Future<Either> leaveTeam(String teamId);

  Future<Either> addQuizToTeam(PutTeamQuizPayload teamQuizzes);

  Future<Either> deleteQuizFromTeam(PutTeamQuizPayload teamQuizzes);
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
      final response = await apiService
          .post('http://$url:5000/api/request-join', {'idTeam': teamId});

      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addTeamService(TeamPayloadModel team) async {
    try {
      final apiService = sl<ApiService>();
      final response =
          await apiService.post('http://$url:5000/api/team', team.toMap());

      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
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
  Future<Either> getListTeamService(String params) async {
    try {
      print(params);
      final apiService = sl<ApiService>();
      final response = await apiService.get('http://$url:5000/api/team?$params');
      if (response.statusCode == 200) {
        List<dynamic> data = (jsonDecode(response.body)["data"]);
        List<TeamModel> teams = data.map((e) => TeamModel.fromMap(e)).toList();
        return Right(teams);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getTeamDetailService(String teamId) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get('http://$url:5000/api/team/$teamId');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body)["data"];
        return Right(TeamModel.fromMap(data));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> kickParticipantService(KickTeamPayLoadModel kickUser) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService
          .put('http://$url:5000/api/team/${kickUser.teamId}', kickUser.toMap());
      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteRequestJoinTeamService(String teamId) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService
          .delete('http://$url:5000/api/request-join', {'idTeam': teamId});

      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getRequest(String teamId) async {
    try {
      var response;
      if (teamId == '') {
        final apiService = sl<ApiService>();
        response =
            await apiService.get('http://$url:5000/api/request-join');
      } else {

        response = await http.get(
            Uri.parse('http://$url:5000/api/request-join?status=pending&idTeam=$teamId'));
      }
      if (response.statusCode == 200) {
        final data =
            (jsonDecode(response.body)["data"] as List<dynamic>)
                .map((e) => JoinRequestModel.fromMap(e))
                .toList();
        return Right(data);
      }
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "api went wrong");
    } catch (e) {

      return Left(e.toString());
    }
  }

  @override
  Future<Either> hostChangeRequest(RequestPayload status) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService
          .put('http://$url:5000/api/request-join/${status.requestId}', status.toMap());
      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> leaveTeam(String teamId) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService
          .post('http://$url:5000/api/team/leave/$teamId',{});
      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addQuizToTeam(PutTeamQuizPayload teamQuizzes) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService
          .put('http://$url:5000/api/team/${teamQuizzes.idTeam}',{'addQuiz':[...teamQuizzes.quizIds]});
      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteQuizFromTeam(PutTeamQuizPayload teamQuizzes) async {
    try {

      final apiService = sl<ApiService>();
      final response = await apiService
          .put('http://$url:5000/api/team/${teamQuizzes.idTeam}',{'removeQuiz':[teamQuizzes.quizIds]});
      print(response.body);
      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }


}
