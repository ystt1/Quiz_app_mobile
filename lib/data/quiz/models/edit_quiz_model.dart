import 'package:intl/intl.dart';
import 'package:quiz_app/data/question/models/basic_question_model.dart';
import 'package:quiz_app/data/quiz/models/topic_model.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

class EditQuizModel {
  final String id;
  final String name;
  final String description;
  final List<TopicModel> topicId;
  final List<BasicQuestionModel> questions;
  final String image;
  final String idCreator;
  final String status;
  final int time;

  EditQuizModel({required this.id, required this.name, required this.description, required this.topicId, required this.questions, required this.image, required this.idCreator, required this.status, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'topicId': this.topicId.map((e)=>e.toMap()).toList(),
      'questions': this.questions.map((e)=>e.toMap()).toList(),
      'image': this.image,
      'idCreator': this.idCreator,
      'status': this.status,
      'time': this.time,
    };
  }

  factory EditQuizModel.fromMap(Map<String, dynamic> map) {
    return EditQuizModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      topicId: map['topicId'] as List<TopicModel>,
      questions: map['questions'] as List<BasicQuestionModel>,
      image: map['image'] as String,
      idCreator: map['idCreator'] as String,
      status: map['status'] as String,
      time: map['time'] as int,
    );
  }
}
