import 'package:quiz_app/domain/user/entity/user_entity.dart';

abstract class GetUserDetailState {}

class GetUserDetailInitial extends GetUserDetailState {}

class GetUserDetailLoading extends GetUserDetailState {}

class GetUserDetailSuccess extends GetUserDetailState {
  final UserEntity user;

  GetUserDetailSuccess({required this.user});
}

class GetUserDetailFailure extends GetUserDetailState {
  final String error;

  GetUserDetailFailure({required this.error});
}
