
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';

abstract class GetAllTopicState {}

class GetAllTopicLoading extends GetAllTopicState{

}
class GetAllTopicSuccess extends GetAllTopicState{
  final List<TopicEntity> topics;

  GetAllTopicSuccess({required this.topics});

}

class GetAllTopicFailure extends GetAllTopicState{
  final String error;
  GetAllTopicFailure({required this.error});
}