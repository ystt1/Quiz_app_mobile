import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';

class SelectTopicCubit extends Cubit<List<TopicEntity>> {
  SelectTopicCubit(super.initialState);


  void onSelect(TopicEntity topic)
  {
    List<TopicEntity> newState = List.from(state);
    if (newState.any((e) => e==topic)) {
      newState.remove(topic);
    } else {
      newState.add(topic);
    }
    emit(newState);
  }
  void onClear()
  {
    emit([]);
  }
}