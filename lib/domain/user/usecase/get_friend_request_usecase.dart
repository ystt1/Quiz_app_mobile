
import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/user/repository/user_repository.dart';
import 'package:quiz_app/service_locator.dart';

class GetFriendRequestUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<UserRepository>().getFriendRequest();
  }

}