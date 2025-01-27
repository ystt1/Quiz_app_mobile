import 'package:quiz_app/data/question/models/basic_question_model.dart';
import 'package:quiz_app/domain/question/entity/basic_answer_entity.dart';

class BasicQuestionEntity {
  final String id;
  final String content;
  final int score;
  final String type;
  final String dateCreated;
  final List<BasicAnswerEntity> answers;

  BasicQuestionEntity(
      {required this.id,
      required this.content,
      required this.score,
      required this.type,
      required this.dateCreated,
      required this.answers});
}

extension BasicQuestionEntityToModel on BasicQuestionEntity {
  BasicQuestionModel toModel() {
    return BasicQuestionModel(
        id: id,
        content: content,
        score: score,
        type: type,
        answers: answers.map((e) => e.toModel()).toList(),
        dateCreated: dateCreated);
  }
}
