import 'package:quiz_app/data/quiz/models/topic_model.dart';

import '../../question/models/basic_question_model.dart';

class EditQuizModel {
  final String? id;
  final String? name;
  final String? description;
  final List<TopicModel>? topicId;
  final List<BasicQuestionModel>? questions;
  final String? image;
  final String? idCreator;
  final String? status;
  final int? time;

  EditQuizModel({
    this.id,
    this.name,
    this.description,
    this.topicId,
    this.questions,
    this.image,
    this.idCreator,
    this.status,
    this.time,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (topicId != null) data['topicId'] = topicId!.map((e) => e.toMap()).toList();
    if (questions != null) data['questions'] = questions!.map((e) => e.toMap()).toList();
    if (image != null) data['image'] = image;
    if (idCreator != null) data['idCreator'] = idCreator;
    if (status != null) data['status'] = status;
    if (time != null) data['time'] = time;
    return data;
  }

  factory EditQuizModel.fromMap(Map<String, dynamic> map) {
    return EditQuizModel(
      id: map['id'] as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      topicId: (map['topicId'] as List<dynamic>?)
          ?.map((e) => TopicModel.fromMap(e))
          .toList(),
      questions: (map['questions'] as List<dynamic>?)
          ?.map((e) => BasicQuestionModel.fromMap(e))
          .toList(),
      image: map['image'] as String?,
      idCreator: map['idCreator'] as String?,
      status: map['status'] as String?,
      time: map['time'] as int?,
    );
  }
}
