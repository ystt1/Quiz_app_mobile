import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/user/model/change_profile_payload_model.dart';
import 'package:quiz_app/domain/user/repository/user_repository.dart';

import '../../../service_locator.dart';

class ChangeProfileUseCase
    implements UseCase<Either, ChangeProfilePayLoadModel> {
  @override
  Future<Either> call({ChangeProfilePayLoadModel? params}) {
    return sl<UserRepository>().changeProfile(params!);
  }
}
