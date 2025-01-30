import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';

class ChangeResultCubit extends Cubit<PracticePayloadModel> {
  ChangeResultCubit(super.initialState);

  void updateAnswer(PracticePayloadModel result)
  {
    emit(result);
  }
}