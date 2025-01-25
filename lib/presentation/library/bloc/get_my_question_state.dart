import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

abstract class GetMyQuestionState{}

class GetMyQuestionLoading extends GetMyQuestionState{}

class GetMyQuestionSuccess extends GetMyQuestionState{
  final List<BasicQuestionEntity> questions;

  GetMyQuestionSuccess({required this.questions});
}

class GetMyQuestionFailure extends GetMyQuestionState{
  final String error;

  GetMyQuestionFailure({required this.error});
}