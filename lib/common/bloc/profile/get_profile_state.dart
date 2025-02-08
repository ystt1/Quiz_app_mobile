import 'package:quiz_app/domain/user/entity/user_entity.dart';

abstract class GetProfileState{}

class GetProfileLoading extends GetProfileState{}

class GetProfileSuccess extends GetProfileState{
  final UserEntity user;
  final String flagAvatar;
  GetProfileSuccess({required this.user,required this.flagAvatar});
}

class GetProfileFailure extends GetProfileState{
  final String error;

  GetProfileFailure({required this.error});

}

class GetProfileEditAvatar extends GetProfileState{
  final UserEntity user;
  final String flagAvatar;

  GetProfileEditAvatar({required this.user, required this.flagAvatar});
}
