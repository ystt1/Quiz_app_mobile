import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/usecase/get_hot_quiz_usecase.dart';
import 'package:quiz_app/presentation/home/bloc/get_hot_quiz_state.dart';

import '../../../service_locator.dart';

class GetHotQuizCubit extends Cubit<GetHotQuizState> {
  GetHotQuizCubit() :super(GetHotQuizLoading());

  Future<void> onGet() async {
    try {
      final response = await sl<GetHotQuizUseCase>().call();
      response.fold((error) => emit(GetHotQuizFailure(error: error)), (data) {
        emit(GetHotQuizSuccess(hotQuiz: data));
      });
    }
    catch (e)
    {
      emit(GetHotQuizFailure(error: e.toString()));
    }
  }
}