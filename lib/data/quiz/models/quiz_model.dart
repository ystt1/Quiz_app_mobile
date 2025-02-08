import 'package:intl/intl.dart';
import 'package:quiz_app/data/question/models/basic_question_model.dart';
import 'package:quiz_app/data/quiz/models/topic_model.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

class BasicQuizModel {
  final String id;
  final String name;
  final String description;
  final List<TopicModel> topicId;
  final List<BasicQuestionModel> questions;
  final String image;
  final String idCreator;
  final String status;
  final int time;
  final String createdAt;
  final int numberQuestion;

  factory BasicQuizModel.fromMap(Map<String, dynamic> map) {
    List<dynamic>? rawQuestions = map['questions'] as List<dynamic>?;

    List<BasicQuestionModel> parsedQuestions = [];
    if (rawQuestions != null) {

      if (rawQuestions.every((item) => item is String)) {
      } else {
        parsedQuestions =
            rawQuestions.map((e) => BasicQuestionModel.fromMap(e)).toList();
      }
    }

    return BasicQuizModel(
      id: map['_id'] as String? ?? '',

      name: map['name'] as String? ?? 'Untitled Quiz',

      description: map['description'] as String? ?? 'No description provided.',
      topicId: (map['topicId'] as List<dynamic>?)
              ?.map((topic) => TopicModel.fromMap(topic))
              .toList() ??
          [],
      questions: parsedQuestions,
      image: map['image'] as String? ?? '',

      idCreator: map['idCreator'] as String? ?? 'Unknown Creator',

      status: map['status'] as String? ?? 'inactive',

      time: map['time'] as int? ?? 0,

      createdAt:DateFormat('dd/MM/yyyy').format(DateTime.parse( map['createdAt'] as String) )??"",

      numberQuestion: rawQuestions?.length ?? 0,
    );
  }

  BasicQuizModel(
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
      required this.numberQuestion});
}

extension BasicQuizModelToEntity on BasicQuizModel {
  BasicQuizEntity toEntity() {
    return BasicQuizEntity(
        id: id,
        name: name,
        description: description,
        topicId: topicId.map((TopicModel topic) => topic.toEntity()).toList(),
        questions: questions
            .map((BasicQuestionModel question) => question.toEntity())
            .toList(),
        image: image,
        idCreator: idCreator,
        status: status,
        time: time,
        createdAt: createdAt,
        questionNumber: numberQuestion);
  }
}
