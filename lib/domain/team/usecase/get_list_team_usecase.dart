import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';
import 'package:quiz_app/service_locator.dart';

class GetListTeamUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) {
    return sl<TeamRepository>().getListTeam();
  }

}