import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/data/quiz/models/quiz_quetion_payload.dart';
import 'package:quiz_app/domain/quiz/usecase/remove_question_from_quiz_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/remove_question_from_quiz_state.dart';
import 'package:quiz_app/service_locator.dart';

class RemoveQuestionFromQuizCubit extends Cubit<RemoveQuestionFromQuizState> {
  RemoveQuestionFromQuizCubit() : super(RemoveQuestionFromQuizLoading());

  Future<void> onGet(QuizQuestionPayload quizQues) async {
    try {
      final returnedData =
          await sl<RemoveQuestionFromQuizUseCase>().call(params: quizQues);
      returnedData.fold(
          (error) => emit(RemoveQuestionFromQuizFailure(error: error)),
          (data) => emit(RemoveQuestionFromQuizSuccess()));
    } catch (e) {
      RemoveQuestionFromQuizFailure(error: e.toString());
    }
  }
}
