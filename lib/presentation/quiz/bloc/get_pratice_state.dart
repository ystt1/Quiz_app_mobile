import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

abstract class GetPracticeQuestionState{}

class GetPracticeQuestionLoading extends GetPracticeQuestionState{}

class GetPracticeQuestionSuccess extends GetPracticeQuestionState{
  final List<BasicQuestionEntity> questions;

  GetPracticeQuestionSuccess({required this.questions});
}

class GetPracticeQuestionFailure extends GetPracticeQuestionState{
  final String error;

  GetPracticeQuestionFailure({required this.error});
}