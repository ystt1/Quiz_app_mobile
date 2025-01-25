import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

abstract class GetNewQuizState{}

class GetNewQuizLoading extends GetNewQuizState{}

class GetNewQuizSuccess extends GetNewQuizState{
  final List<BasicQuizEntity> newQuiz;

  GetNewQuizSuccess({required this.newQuiz});
}

class GetNewQuizFailure extends GetNewQuizState{
  final String error;

  GetNewQuizFailure({required this.error});
}