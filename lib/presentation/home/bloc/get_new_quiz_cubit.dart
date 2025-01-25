import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/usecase/get_newest_quiz_usecase.dart';
import 'package:quiz_app/presentation/home/bloc/get_new_quiz_state.dart';
import 'package:quiz_app/service_locator.dart';

class GetNewQuizCubit extends Cubit<GetNewQuizState> {
  GetNewQuizCubit() : super(GetNewQuizLoading());

  Future<void> onGet() async {
    try {
      final response = await sl<GetNewestQuizUseCase>().call();
      response.fold((error) => emit(GetNewQuizFailure(error: error)), (data) {
        emit(GetNewQuizSuccess(newQuiz: data));
      });
    }
    catch (e)
    {
    emit(GetNewQuizFailure(error: e.toString()));
    }
  }
}
