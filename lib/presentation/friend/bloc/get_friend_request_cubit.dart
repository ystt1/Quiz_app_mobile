import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_request_state.dart';

class GetFriendRequestCubit extends Cubit<GetFriendRequestState> {
  GetFriendRequestCubit() : super(GetFriendRequestLoading());

  onGet({required UseCase useCase, dynamic params}) async {
    try {
      emit(GetFriendRequestLoading());
      Either returnedData = await useCase.call(params: params);
      returnedData.fold((error) => emit(GetFriendRequestFailure(error: error)),
          (data) => emit(GetFriendRequestSuccess(users: data)));
    } catch (e) {
      emit(GetFriendRequestFailure(error: e.toString()));
    }
  }

  onRemove(SimpleUserEntity user)
  {
    if(state is GetFriendRequestSuccess)
    {
      List<SimpleUserEntity> userList=(state as GetFriendRequestSuccess).users;
      userList.remove(user);
      emit(GetFriendRequestSuccess(users: userList));
    }
  }
}
