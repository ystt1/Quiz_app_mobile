import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/usecase/get_quiz_detail_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_state.dart';
import 'package:quiz_app/service_locator.dart';

class GetQuizDetailCubit extends Cubit<GetQuizDetailState> {
  GetQuizDetailCubit() : super(GetQuizDetailLoading());

  Future<void> onGet(String id) async {
    try {
      final returnedData = await sl<GetQuizDetailUseCase>().call(params: id);
      returnedData.fold((error) => emit(GetQuizDetailFailure(error: error)),
          (data) => (emit(GetQuizDetailSuccess(quiz: data))));
    } catch (e) {
      emit(GetQuizDetailFailure(error: e.toString()));
    }
  }
}
