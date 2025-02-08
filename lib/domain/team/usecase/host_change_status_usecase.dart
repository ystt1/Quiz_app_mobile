import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/team/model/request_payload_model.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';
import 'package:quiz_app/service_locator.dart';

class HostChangeStatusUseCase implements UseCase<Either,RequestPayload> {
  @override
  Future<Either> call({RequestPayload? params}) async {
   return await sl<TeamRepository>().hostChangeJoinRequest(params!);
  }

}