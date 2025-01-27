import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/usecase/get_all_topic_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_state.dart';

import '../../../service_locator.dart';

class GetAllTopicCubit extends Cubit<GetAllTopicState> {
  GetAllTopicCubit() : super(GetAllTopicLoading());

  Future<void> onGet() async {
    try {
      final returnedData = await sl<GetAllTopicUseCase>().call();
      returnedData.fold((error) => emit(GetAllTopicFailure(error: error)),
          (data) => emit(GetAllTopicSuccess(topics: data)));
    } catch (e) {
      emit(GetAllTopicFailure(error: e.toString()));
    }
  }
}
