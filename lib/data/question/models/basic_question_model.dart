import 'package:intl/intl.dart';
import 'package:quiz_app/data/question/models/basic_answer_model.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class BasicQuestionModel {
  final String id;
  final String content;
  final int score;
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

  Map<String, dynamic> toMap() {
    return {
      '_id': this.id,
      'content': this.content,
      'score': this.score,
      'type': this.type,
      'answers': this.answers.map((e)=>e.toMap()).toList(),
      'dateCreated': this.dateCreated,
    };
  }

  factory BasicQuestionModel.fromMap(Map<String, dynamic> map) {
    return BasicQuestionModel(
      id: map['_id'] as String,
      content: map['content'] as String,
      score: map['score'] as int,
      type: map['type'] as String,
      answers: (map['answers'] as List<dynamic>).map((e)=>BasicAnswerModel.fromMap(e)).toList(),
      dateCreated:DateFormat('dd/MM/yyyy').format(DateTime.parse( map['createdAt'] as String) )??"",
    );
  }
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
