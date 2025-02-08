import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/team/get_joined_status_state.dart';
import 'package:quiz_app/domain/team/entity/join_request_entity.dart';
import 'package:quiz_app/domain/team/usecase/get_list_request_usecase.dart';
import 'package:quiz_app/service_locator.dart';

class GetJoinedStatusCubit extends Cubit<GetJoinedStatusState> {
  GetJoinedStatusCubit() : super(GetJoinedStatusLoading());

  onGet(String idTeam) async {
    try {
      final returnedData =
          await sl<GetListRequestUseCase>().call(params: idTeam);
      returnedData.fold((error) => emit(GetJoinedStatusFailure(error: error)),
          (data) => emit(GetJoinedStatusSuccess(requests: data)));
    } catch (e) {
      emit(GetJoinedStatusFailure(error: e.toString()));
    }
  }

  onRemoveStatusCode(int index) async {
    if (state is GetJoinedStatusSuccess) {
      List<JoinRequestEntity> requests =
          (state as GetJoinedStatusSuccess).requests;
      requests.removeAt(index);
      emit(GetJoinedStatusSuccess(requests: requests));
    }
  }
}
