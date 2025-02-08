import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/team/model/kick_team_payload_model.dart';

import '../../../service_locator.dart';
import '../repository/team_repository.dart';

class KickParticipantUseCase implements UseCase<Either,KickTeamPayLoadModel> {
  @override
  Future<Either> call({KickTeamPayLoadModel? params}) async {
    return await sl<TeamRepository>().kickParticipant(params!);
  }

}