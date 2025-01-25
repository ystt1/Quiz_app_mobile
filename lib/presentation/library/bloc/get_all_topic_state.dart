import 'package:quiz_app/data/quiz/models/topic_model.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';

abstract class GetAllTopicState {}

class GetAllTopicLoading{

}

class GetAllTopicSuccess{
  final List<TopicEntity> topics;

  GetAllTopicSuccess({required this.topics});

}


class GetAllTopicFailure{
  final String error;
  GetAllTopicFailure({required this.error});
}