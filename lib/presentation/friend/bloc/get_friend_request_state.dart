import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

abstract class GetFriendRequestState{}

class GetFriendRequestLoading extends GetFriendRequestState{}

class GetFriendRequestSuccess extends GetFriendRequestState{
  final List<SimpleUserEntity> users;

  GetFriendRequestSuccess({required this.users});
}

class GetFriendRequestFailure extends GetFriendRequestState{
final String error;

  GetFriendRequestFailure({required this.error});
}