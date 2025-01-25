import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

abstract class GetMyQuizState{}

class GetMyQuizLoading extends GetMyQuizState{}

class GetMyQuizSuccess extends GetMyQuizState{
  final List<BasicQuizEntity> myQuiz;
  GetMyQuizSuccess({required this.myQuiz});
}
class GetMyQuizFailure extends GetMyQuizState{
  final String error;

  GetMyQuizFailure({required this.error});
}


