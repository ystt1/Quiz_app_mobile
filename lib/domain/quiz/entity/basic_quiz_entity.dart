import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';

class BasicQuizEntity {
  final String id;
  final String name;
  final String description;
  final List<TopicEntity> topicId;
  final List<BasicQuestionEntity> questions;
  final String image;
  final String idCreator;
  final String status;
  final int time;
  final String createdAt;
  final int questionNumber;

  BasicQuizEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.topicId,
      required this.questions,
      required this.image,
      required this.idCreator,
      required this.status,
      required this.time,
      required this.createdAt,
      required this.questionNumber});
}

extension BasicQuizEntityToModel on BasicQuizEntity {
  BasicQuizModel toModel() {
    return BasicQuizModel(
        id: id,
        name: name,
        description: description,
        topicId: topicId.map((e)=>e.toModel()).toList(),
        questions: questions.map((e)=>e.toModel()).toList(),
        image: image,
        idCreator: idCreator,
        status: status,
        time: time,
        createdAt: createdAt,
        numberQuestion: questionNumber);
  }
}
