import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/user/get_list_user_state.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/service_locator.dart';

class GetListUserCubit extends Cubit<GetListUserState> {
  GetListUserCubit() : super(GetListUserInitial());

  onGet({required UseCase usecase, required dynamic params}) async {
    try {
      emit(GetListUserLoading());
      Either returnedData = await usecase.call(params: params);
      returnedData.fold((error) => emit(GetListUserFailure(error: error)),
              (data) => emit(GetListUserSuccess(users: data)));
    }
    catch (e)
    {
      emit(GetListUserFailure(error: e.toString()));
    }
  }
}
