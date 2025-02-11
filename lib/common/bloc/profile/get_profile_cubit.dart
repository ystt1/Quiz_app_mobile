import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/profile/get_profile_state.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/user/entity/user_entity.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  GetProfileCubit() : super(GetProfileLoading());

  onGet({required UseCase useCase, dynamic params}) async {
    emit(GetProfileLoading());
    try {
      Either returnedData = await useCase.call(params: params);
      returnedData.fold(
          (error) => emit(GetProfileFailure(error: error)),
          (data) => emit(GetProfileSuccess(
              user: data, flagAvatar: (data as UserEntity).avatar)));
    } catch (e) {
      emit(GetProfileFailure(error: e.toString()));
    }
  }

  onChangeAvatar(String? base64Avatar) async {
    if (base64Avatar != null) {
      if (state is GetProfileSuccess) {
        final currentState = state as GetProfileSuccess;
        emit(GetProfileSuccess(
            user: currentState.user, flagAvatar: base64Avatar));
      }
    }
  }

  onChangeAvatarSuccess() async {
    if (state is GetProfileSuccess) {
      final currentState = state as GetProfileSuccess;
      UserEntity newUser = UserEntity(
        id: currentState.user.id,
        userName: currentState.user.userName,
        avatar: currentState.flagAvatar,
        email: currentState.user.email,
        createdAt: currentState.user.createdAt,
        friendCount: currentState.user.friendCount,
        friendshipStatus: currentState.user.friendshipStatus,
        quizCount: currentState.user.quizCount,
        questionCount: currentState.user.questionCount,
        totalScore: currentState.user.totalScore,
      );
      emit(GetProfileSuccess(
          user: newUser, flagAvatar: currentState.flagAvatar));
    }
  }

  cancelAvatarChange() async {
    if (state is GetProfileSuccess) {
      final currentState = state as GetProfileSuccess;
      emit(GetProfileSuccess(
          user: currentState.user, flagAvatar: currentState.user.avatar));
    }
  }

  onChangeStatus() async {
    if (state is GetProfileSuccess) {
      final currentState = state as GetProfileSuccess;
      String status = 'none';
      switch (currentState.user.friendshipStatus) {
        case 'none':
          status = 'request_sent';
          break;
        case 'request_sent':
          status = 'none';
          break;
        case 'request_received':
          status = 'friends';
          break;
        default:
          break;
      }
      UserEntity newUser = UserEntity(
        id: currentState.user.id,
        userName: currentState.user.userName,
        avatar: currentState.flagAvatar,
        email: currentState.user.email,
        createdAt: currentState.user.createdAt,
        friendCount: currentState.user.friendCount,
        friendshipStatus: status,
        quizCount: currentState.user.quizCount,
        questionCount: currentState.user.questionCount,
        totalScore: currentState.user.totalScore,
      );
      emit(GetProfileSuccess(
          user: newUser, flagAvatar: currentState.flagAvatar));
    }
  }
}
