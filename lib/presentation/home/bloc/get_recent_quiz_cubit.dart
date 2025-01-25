import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/presentation/home/bloc/get_recent_quiz_state.dart';

import '../../../domain/quiz/usecase/get_recent_quiz_usecase.dart';
import '../../../service_locator.dart';

class GetRecentQuizCubit extends Cubit<GetRecentQuizState> {
  GetRecentQuizCubit() : super(GetRecentQuizLoading());

  Future<void> onGet() async {
    try {
      final response = await sl<GetRecentQuizUseCase>().call();
      response.fold((error) => emit(GetRecentQuizFailure(error: error)),
          (data) {
        emit(GetRecentQuizSuccess(recentQuiz: data));
      });
    } catch (e) {
      emit(GetRecentQuizFailure(error: e.toString()));
    }
  }
}
