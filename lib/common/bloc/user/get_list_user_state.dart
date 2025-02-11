import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

abstract class GetListUserState{}

class GetListUserInitial extends GetListUserState{}

class GetListUserLoading extends GetListUserState{}

class GetListUserFailure extends GetListUserState{
  final String error;

  GetListUserFailure({required this.error});
}

class GetListUserSuccess extends GetListUserState{
  final List<SimpleUserEntity> users;

  GetListUserSuccess({required this.users});
}