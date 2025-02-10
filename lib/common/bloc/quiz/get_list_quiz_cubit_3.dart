import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';


import '../../../core/usecase.dart';
import 'get_list_quiz_state_3.dart';

class GetListQuizCubit3 extends Cubit<GetListQuizState3> {
  GetListQuizCubit3() : super(GetListQuizInitialState3());
  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(GetListQuizLoading3());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold((error) {
        emit(GetListQuizFailure3(error: error));
      }, (data) {
        emit(GetListQuizSuccess3(quizzes: data));
      });
    } catch (e) {
      emit(GetListQuizFailure3(error: e.toString()));
    }
  }


}
