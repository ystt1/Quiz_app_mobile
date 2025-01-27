import 'package:quiz_app/data/quiz/models/topic_model.dart';

class TopicEntity{
  final String id;
  final String name;

  TopicEntity({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TopicEntity &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

extension TopicEntityToModels on TopicEntity
{
  TopicModel toModel()
  {
    return TopicModel(id: id, name: name);
  }
}