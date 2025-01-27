import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/domain/quiz/usecase/get_list_my_quiz_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_quiz_state.dart';

import '../../../service_locator.dart';

class GetMyQuizCubit extends Cubit<GetMyQuizState> {
  GetMyQuizCubit() : super(GetMyQuizLoading());

  Future<void> onGet(SearchAndSortModel searchSort) async {
    try {
      final response = await sl<GetListMyQuizUseCase>().call(params: searchSort);
      response.fold((error) => emit(GetMyQuizFailure(error: error)), (data) {
        emit(GetMyQuizSuccess(myQuiz: data));
      });
    } catch (e) {
      emit(GetMyQuizFailure(error: e.toString()));
    }
  }
}
