import 'package:dartz/dartz.dart';

abstract class TeamRepository{
  Future<Either> acceptRequest();
  Future<Either> addRequestJoinTeam();
  Future<Either> addTeam();
  Future<Either> editTeamDetail();
  Future<Either> getListTeam();
  Future<Either> getTeamDetail();
  Future<Either> kickParticipant();
}