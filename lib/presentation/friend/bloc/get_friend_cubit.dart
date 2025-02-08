import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_state.dart';


class GetFriendCubit extends Cubit<GetFriendState> {
  GetFriendCubit() : super(GetFriendLoading());

  onGet({required UseCase useCase, dynamic params}) async {
    try {
      emit(GetFriendLoading());
      Either returnedData = await useCase.call(params: params);
      returnedData.fold((error) => emit(GetFriendFailure(error: error)),
              (data) => emit(GetFriendSuccess(users: data)));
    } catch (e) {
      emit(GetFriendFailure(error: e.toString()));
    }
  }

  onAdd(SimpleUserEntity user)
  {
    if(state is GetFriendSuccess)
      {
        List<SimpleUserEntity> userList=(state as GetFriendSuccess).users;
        userList.add(user);
        emit(GetFriendSuccess(users: userList));
      }
  }
}
