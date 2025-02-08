import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/result/get_list_result_state.dart';
import '../../../core/usecase.dart';

class GetListResultCubit extends Cubit<GetListResultState> {
  GetListResultCubit() : super(GetListResultInitialState());
  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(GetListResultLoading());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold((error) {
        emit(GetListResultFailure(error: error));
      }, (data) {
        emit(GetListResultSuccess(results: data));
      });
    } catch (e) {
      emit(GetListResultFailure(error: e.toString()));
    }
  }


}
