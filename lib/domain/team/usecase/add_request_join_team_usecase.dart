import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';
import 'package:quiz_app/service_locator.dart';

class AddRequestJoinTeamUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<TeamRepository>().addRequestJoinTeam(params!);
  }

}