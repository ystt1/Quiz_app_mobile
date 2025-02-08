import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/team/model/put_team_quiz_payload.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';

import '../../../service_locator.dart';

class AddQuizToTeamUseCase implements UseCase<Either,PutTeamQuizPayload> {
  @override
  Future<Either> call({PutTeamQuizPayload? params}) async {
    return await sl<TeamRepository>().addQuizToTeam(params!);
  }

}