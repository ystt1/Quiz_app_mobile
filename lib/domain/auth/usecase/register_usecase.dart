import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/auth/models/register_payload.dart';
import 'package:quiz_app/domain/auth/repository/auth_repository.dart';
import 'package:quiz_app/service_locator.dart';

class RegisterUseCase implements UseCase<Either,RegisterPayload> {
  @override
  Future<Either> call({RegisterPayload? params}) async {
    return await sl<AuthRepository>().register(params!);
  }

}