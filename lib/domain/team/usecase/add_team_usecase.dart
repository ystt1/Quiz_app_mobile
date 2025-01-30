import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/team/model/team_payload_model.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';
import 'package:quiz_app/service_locator.dart';

class AddTeamUseCase implements UseCase<Either,TeamPayloadModel> {
  @override
  Future<Either> call({TeamPayloadModel? params}) async {
   return await sl<TeamRepository>().addTeam(params!);
  }

}