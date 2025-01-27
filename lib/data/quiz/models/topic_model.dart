import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';

class TopicModel {
  final String id;
  final String name;

  TopicModel({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      '_id': this.id,
      'name': this.name,
    };
  }

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      id: map['_id'] as String,
      name: map['name'] as String,
    );
  }
}

extension TopicModelToEntity on TopicModel {
  TopicEntity toEntity() {
    return TopicEntity(id: id, name: name);
  }
}
