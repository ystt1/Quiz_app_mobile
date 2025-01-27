import 'package:quiz_app/data/quiz/models/topic_model.dart';

class QuizPayloadModel
{

  final String name;
  final String description;
  final List<TopicModel> topicId;
  final String image;
  final String idCreator;
  final String status="inactive";
  final int time;

  QuizPayloadModel({ required this.name, required this.description, required this.topicId, required this.image, required this.idCreator, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'description': this.description,
      'topicId': this.topicId.map((topic) => topic.toMap()).toList(),
      'image': this.image,
      'idCreator': this.idCreator,
      'status': this.status,
      'time': this.time,
    };
  }


}