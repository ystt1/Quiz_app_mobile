import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';

class BasicQuizEntity {
  final String id;
  late String name;
  late String description;
  late List<TopicEntity> topicId;
  late  List<BasicQuestionEntity> questions;
  late String image;
  final String idCreator;
  late String status;
  late int time;
  final String createdAt;
  late  int questionNumber;

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

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'topicId': this.topicId,
      'questions': this.questions,
      'image': this.image,
      'idCreator': this.idCreator,
      'status': this.status,
      'time': this.time,
      'createdAt': this.createdAt,
      'questionNumber': this.questionNumber,
    };
  }
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
