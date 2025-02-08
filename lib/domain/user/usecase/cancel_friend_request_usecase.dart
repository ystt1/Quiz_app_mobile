import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/user/repository/user_repository.dart';

import '../../../service_locator.dart';

class CancelFriendRequestUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<UserRepository>().cancelFriendRequest(params!);
  }

}