import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';


import '../../../core/usecase.dart';

class GetListQuizCubit extends Cubit<GetListQuizState> {
  GetListQuizCubit() : super(GetListQuizInitialState());
  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(GetListQuizLoading());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold((error) {
        emit(GetListQuizFailure(error: error));
      }, (data) {
        emit(GetListQuizSuccess(quizzes: data));
      });
    } catch (e) {
      emit(GetListQuizFailure(error: e.toString()));
    }
  }

  onRemoveQuiz(List<BasicQuizEntity> quizzes)
  {
    if (state is GetListQuizSuccess) {
      final currentState = state as GetListQuizSuccess;
      List<BasicQuizEntity> updatedListQuizzes=List.from(currentState.quizzes);
      updatedListQuizzes.removeWhere((quiz) => quizzes.contains(quiz));
      emit(GetListQuizSuccess(quizzes: updatedListQuizzes));
    }
  }


  onUpdateQuiz(BasicQuizEntity quiz)
  {
    if (state is GetListQuizSuccess) {
      final currentState = state as GetListQuizSuccess;
      List<BasicQuizEntity> updatedListQuizzes=currentState.quizzes.map((e){
        if(e.id==quiz.id)
          {
            return quiz;
          }
        return e;
      }).toList();

      emit(GetListQuizSuccess(quizzes: updatedListQuizzes));
    }
  }
}
