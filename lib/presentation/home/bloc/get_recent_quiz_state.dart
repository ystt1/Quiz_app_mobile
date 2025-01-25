import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

abstract class GetRecentQuizState{}

class GetRecentQuizLoading extends GetRecentQuizState{}

class GetRecentQuizSuccess extends GetRecentQuizState{
  final List<BasicQuizEntity> recentQuiz;
  GetRecentQuizSuccess({required this.recentQuiz});
}
class GetRecentQuizFailure extends GetRecentQuizState{
  final String error;

  GetRecentQuizFailure({required this.error});
}


