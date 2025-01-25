import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/auth/models/login_payload.dart';
import 'package:quiz_app/data/auth/models/register_payload.dart';
import 'package:quiz_app/data/auth/models/token_get_model.dart';
import 'package:quiz_app/data/auth/service/auth_service.dart';
import 'package:quiz_app/domain/auth/repository/auth_repository.dart';

import '../../../service_locator.dart';

class AuthRepositoryImp extends AuthRepository {
  @override
  Future<Either> login(LoginPayLoad loginPayload) async {
    try {
      final response = await sl<AuthService>().login(loginPayload);
      return response.fold((error) => Left(error), (tokenGetModel) {
        var entity = (tokenGetModel as TokenGetModel).toEntity();
        return Right(entity);
      });
    }
    catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> register(RegisterPayload registerPayload) async {
    try {
      final response = await sl<AuthService>().register(registerPayload);
      return response;
    }
    catch (e) {
      return Left(e.toString());
    }
  }
}
