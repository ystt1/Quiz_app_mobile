import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

abstract class GetHotQuizState{}

class GetHotQuizLoading extends GetHotQuizState{}

class GetHotQuizSuccess extends GetHotQuizState{
  final List<BasicQuizEntity> hotQuiz;
  GetHotQuizSuccess({required this.hotQuiz});
}
class GetHotQuizFailure extends GetHotQuizState{
  final String error;

  GetHotQuizFailure({required this.error});
}


