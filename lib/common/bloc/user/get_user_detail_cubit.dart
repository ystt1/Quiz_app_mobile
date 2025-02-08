import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_state.dart';
import 'package:quiz_app/domain/user/usecase/get_user_detail_usecase.dart';

import 'package:quiz_app/service_locator.dart';

class GetUserDetailCubit extends Cubit<GetUserDetailState> {
  GetUserDetailCubit() : super(GetUserDetailInitial());


  Future<void> onGet(String id) async {
    emit(GetUserDetailLoading());
    try {
      final returnedData = await sl<GetUserDetailUseCase>().call(params: id);
      returnedData.fold((error) => emit(GetUserDetailFailure(error: error)),
              (data) => emit(GetUserDetailSuccess(user: data)));

    }
    catch (e)
    {
      emit(GetUserDetailFailure(error: e.toString()));
    }
  }
}
