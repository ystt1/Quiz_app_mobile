import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_state.dart';

class GetTeamCubit extends Cubit<GetTeamState> {
  GetTeamCubit():super(GetTeamLoading());

  onGet({dynamic params, required UseCase usecase})
  async {
    emit(GetTeamLoading());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold((error) {
        emit(GetTeamFailure(error: error));
      }, (data) {
        emit(GetTeamSuccess(teams: data));
      });
    } catch (e) {
      emit(GetTeamFailure(error: e.toString()));
    }
  }

}