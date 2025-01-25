import 'package:dartz/dartz.dart';

abstract class TeamService{
  Future<Either> acceptRequestService();
  Future<Either> addRequestJoinTeamService();
  Future<Either> addTeamService();
  Future<Either> editTeamDetailService();
  Future<Either> getListTeamService();
  Future<Either> getTeamDetailService();
  Future<Either> kickParticipantService();
}

class TeamServiceImp extends TeamService {
  @override
  Future<Either> acceptRequestService() {
    // TODO: implement acceptRequestService
    throw UnimplementedError();
  }

  @override
  Future<Either> addRequestJoinTeamService() {
    // TODO: implement addRequestJoinTeamService
    throw UnimplementedError();
  }

  @override
  Future<Either> addTeamService() {
    // TODO: implement addTeamService
    throw UnimplementedError();
  }

  @override
  Future<Either> editTeamDetailService() {
    // TODO: implement editTeamDetailService
    throw UnimplementedError();
  }

  @override
  Future<Either> getListTeamService() {
    // TODO: implement getListTeamService
    throw UnimplementedError();
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

}