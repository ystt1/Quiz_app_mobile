import 'package:quiz_app/data/question/models/basic_answer_model.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class BasicQuestionModel {
  final String id;
  final String content;
  final String score;
  final String type;
  final List<BasicAnswerModel> answers;
  final String dateCreated;

  BasicQuestionModel(
      {required this.id,
      required this.content,
      required this.score,
      required this.type,
      required this.answers,
      required this.dateCreated});
}

extension BasicQuestionModelToEntity on BasicQuestionModel {
  BasicQuestionEntity toEntity() {
    return BasicQuestionEntity(
        id: id,
        content: content,
        score: score,
        type: type,
        answers: answers.map((BasicAnswerModel e) => e.toEntity()).toList(),
        dateCreated: dateCreated);
  }
}
