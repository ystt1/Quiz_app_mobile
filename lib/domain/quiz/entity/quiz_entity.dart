import 'package:quiz_app/domain/question/entity/question_entity.dart';

class QuizEntity {
  final String quizName;
  final String quizDescription;
  final String quizImageUrl;
  final List<String> topics;
  final int time;
  final String createdDate;
  final bool isPrivate;
  final List<QuestionEntity> questions;

  QuizEntity({required this.quizName, required this.quizDescription, required this.quizImageUrl, required this.topics, required this.time, required this.createdDate, required this.isPrivate, required this.questions});


}