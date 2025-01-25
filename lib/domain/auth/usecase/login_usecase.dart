import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/auth/models/login_payload.dart';
import 'package:quiz_app/domain/auth/repository/auth_repository.dart';
import 'package:quiz_app/service_locator.dart';

class LoginUseCase implements UseCase<Either,LoginPayLoad> {
  @override
  Future<Either> call({LoginPayLoad? params}) async {
    return await sl<AuthRepository>().login(params!);
  }

}