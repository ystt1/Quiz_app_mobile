import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

abstract class GetFriendState{}

class GetFriendLoading extends GetFriendState{}

class GetFriendSuccess extends GetFriendState{
  final List<SimpleUserEntity> users;

  GetFriendSuccess({required this.users});
}

class GetFriendFailure extends GetFriendState{
  final String error;

  GetFriendFailure({required this.error});
}