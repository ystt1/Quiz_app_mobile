import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';

import '../../../service_locator.dart';

class LeaveTeamUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<TeamRepository>().leaveTeam(params!);
  }

}