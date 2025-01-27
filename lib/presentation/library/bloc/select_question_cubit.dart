import 'package:flutter_bloc/flutter_bloc.dart';

class SelectQuestionCubit extends Cubit<List<String>> {
  SelectQuestionCubit():super([]);
  void onSelect(String id)
  {
    List<String> newState = List.from(state);
    if (newState.contains(id)) {
      newState.remove(id);
    } else {
      newState.add(id);
    }

    emit(newState);
  }
  void onClear()
  {

    emit([]);
  }
}