import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/quiz/usecase/submit_result_usecase.dart';
import 'package:quiz_app/presentation/quiz/bloc/submit_state.dart';
import 'package:quiz_app/service_locator.dart';

class SubmitCubit extends Cubit<SubmitState> {
  SubmitCubit():super(SubmitLoading());

  onSubmit(PracticePayloadModel result)
  async {
    try {
      emit(SubmitLoading());
      final returnedData = await sl<SubmitResultUseCase>().call(params: result);
      return returnedData.fold((error) => emit(SubmitFailure(error: error)), (
          data) => emit(SubmitSuccess(result: data)));
    }
    catch (e)
    {
      return emit(SubmitFailure(error: e.toString()));
    }
  }
}