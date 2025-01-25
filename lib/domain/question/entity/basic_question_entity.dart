import 'package:quiz_app/domain/question/entity/basic_answer_entity.dart';

class BasicQuestionEntity{
  final String id;
  final String content;
  final String score;
  final String type;
  final String dateCreated;
  final List<BasicAnswerEntity> answers;

  BasicQuestionEntity({required this.id, required this.content, required this.score, required this.type, required this.dateCreated, required this.answers});


}