import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/conversation/get_list_conversaton_state.dart';
import 'package:quiz_app/core/usecase.dart';

class GetListConversationCubit extends Cubit<GetListConversationState> {
  GetListConversationCubit():super(GetListConversationLoading());

  onGet({dynamic params, required UseCase usecase})
  async {
    emit(GetListConversationLoading());
    try {
      Either returnedData = await usecase.call(params: params);
      returnedData.fold((error) {
        emit(GetListConversationFailure(error: error));
      }, (data) {
        emit(GetListConversationSuccess(conversations: data));
      });
    } catch (e) {
      emit(GetListConversationFailure(error: e.toString()));
    }
  }
}