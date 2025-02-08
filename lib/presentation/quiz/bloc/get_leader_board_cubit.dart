import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/usecase/get_leader_board_usecase.dart';
import 'package:quiz_app/presentation/quiz/bloc/get_leader_board_state.dart';
import 'package:quiz_app/service_locator.dart';

class GetLeaderBoardCubit extends Cubit<GetLeaderBoardState> {
  GetLeaderBoardCubit() : super(GetLeaderBoardLoading());

  onGet(String id) async {
    emit(GetLeaderBoardLoading());
    try {
      final returnedData = await sl<GetLeaderBoardUseCase>().call(params: id);
      returnedData.fold((error) => emit(GetLeaderBoardFailure(error: error)),
          (data) => emit(GetLeaderBoardSuccess(leaderBoard: data)));
    } catch (e) {
      emit(GetLeaderBoardFailure(error: e.toString()));
    }
  }
}
