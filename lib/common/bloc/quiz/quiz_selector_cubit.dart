import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

class QuizSelectorCubit extends Cubit<List<BasicQuizEntity>> {
  QuizSelectorCubit():super([]);


  onSelect(BasicQuizEntity quiz)
  {
    List<BasicQuizEntity> flag=List.from(state);
    if(state.contains(quiz)){
      flag.remove(quiz);
    }
    else{
      flag.add(quiz);
    }

    emit(flag);
  }

  onClear()
  {
   emit([]);
  }
}