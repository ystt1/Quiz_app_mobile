import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/question/usecase/get_my_question_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_question_state.dart';

import '../../../service_locator.dart';

class GetMyQuestionCubit extends Cubit<GetMyQuestionState> {
  GetMyQuestionCubit() : super(GetMyQuestionLoading());

  Future<void> onGet() async {
    try {
      final response = await sl<GetMyQuestionUseCase>().call();
      response.fold((error) => emit(GetMyQuestionFailure(error: error)),
          (data) => emit(GetMyQuestionSuccess(questions: data)));
    } catch (e) {
      emit(GetMyQuestionFailure(error: e.toString()));
    }
  }
}
