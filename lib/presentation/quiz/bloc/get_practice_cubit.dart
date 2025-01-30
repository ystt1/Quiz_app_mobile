import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/presentation/quiz/bloc/get_pratice_state.dart';



import '../../../domain/question/usecase/get_list_practice_usecase.dart';
import '../../../service_locator.dart';

class GetPracticeQuestionCubit extends Cubit<GetPracticeQuestionState> {
  GetPracticeQuestionCubit() : super(GetPracticeQuestionLoading());

  Future<void> onGet(String quizId) async {
    emit(GetPracticeQuestionLoading());
    try {
      final response = await sl<GetListPracticeUsecase>().call(params: quizId);
      response.fold((error) => emit(GetPracticeQuestionFailure(error: error)),
              (data) => emit(GetPracticeQuestionSuccess(questions: data)));
    } catch (e) {
      emit(GetPracticeQuestionFailure(error: e.toString()));
    }
  }
}
