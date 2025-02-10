import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';


import '../../../core/usecase.dart';
import 'get_list_quiz_state_2.dart';

class GetListQuizCubit2 extends Cubit<GetListQuizState2> {
  GetListQuizCubit2() : super(GetListQuizInitialState2());
  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(GetListQuizLoading2());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold((error) {
        emit(GetListQuizFailure2(error: error));
      }, (data) {
        emit(GetListQuizSuccess2(quizzes: data));
      });
    } catch (e) {
      emit(GetListQuizFailure2(error: e.toString()));
    }
  }


}
