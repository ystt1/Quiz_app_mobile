import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_state.dart';

class GetTeamCubit extends Cubit<GetTeamState> {
  GetTeamCubit() : super(GetTeamLoading());

  onGet({dynamic params, required UseCase usecase}) async {
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

  void onChangeStatus(String status, TeamEntity team) {
    if (state is GetTeamSuccess) {
      List<TeamEntity> teams = (state as GetTeamSuccess).teams.map((e) {
        if (e.id == team.id) {
          return TeamEntity(
              id: e.id,
              idHost: e.idHost,
              name: e.name,
              image: e.image,
              maxParticipant: e.maxParticipant,
              code: e.code,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              joinStatus: status,
              members: e.members,
              memberCount: e.memberCount,
              quizCount: e.quizCount,
              quizzes: e.quizzes);
        }
        return e;
      }).toList();

      emit(GetTeamSuccess(teams: teams));
    }
  }
}
