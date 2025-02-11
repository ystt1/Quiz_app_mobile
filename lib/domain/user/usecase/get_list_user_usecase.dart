import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/user/repository/user_repository.dart';
import 'package:quiz_app/service_locator.dart';

class GetListUserUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String? params}) {
    return sl<UserRepository>().getListFriends(params!);
  }

}