import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/usecase/search_list_quiz_usecase.dart';
import 'package:quiz_app/presentation/search/bloc/get_list_quiz_search_state.dart';

import '../../../service_locator.dart';

class GetListQuizSearchCubit extends Cubit<GetListQuizSearchState> {
  GetListQuizSearchCubit() : super(GetListQuizSearchInitial());

  Future<void> onGet(String search) async {
    try {
      emit(GetListQuizSearchLoading());
      final response = await sl<SearchListQuizUseCase>().call();
      response.fold((error) => emit(GetListQuizSearchFailure(error: error)),
          (data) {
        emit(GetListQuizSearchSuccess(listQuiz: data));
      });
    } catch (e) {
      emit(GetListQuizSearchFailure(error: e.toString()));
    }
  }
}
