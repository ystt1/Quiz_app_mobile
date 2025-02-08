import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/domain/team/entity/team_member_entity.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_detail_state.dart';

class GetTeamDetailCubit extends Cubit<GetTeamDetailState> {


  List<TeamMemberEntity> _allMembers = [];
  GetTeamDetailCubit() : super(GetTeamDetailLoading());

  onGet({dynamic params, required UseCase usecase}) async {
    emit(GetTeamDetailLoading());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold((error) {
        emit(GetTeamDetailFailure(error: error));
      }, (data) {
        _allMembers = data.members;
        emit(GetTeamDetailSuccess(team: data));
      });
    } catch (e) {
      emit(GetTeamDetailFailure(error: e.toString()));
    }
  }

  onKickUser(TeamMemberEntity member) {
    if (state is GetTeamDetailSuccess) {
      final currentState = state as GetTeamDetailSuccess;
      currentState.team.members.remove(member);
      _allMembers.remove(member);
      emit(GetTeamDetailSuccess(team: currentState.team));
    }
  }

  onAddQuiz(List<BasicQuizEntity> quizzes) {
    if (state is GetTeamDetailSuccess) {
      final currentState = state as GetTeamDetailSuccess;
      var updatedTeam = TeamEntity(
          id: currentState.team.id,
          idHost: currentState.team.idHost,
          name: currentState.team.name,
          image: currentState.team.image,
          maxParticipant: currentState.team.maxParticipant,
          code: currentState.team.code,
          createdAt: currentState.team.createdAt,
          updatedAt: currentState.team.updatedAt,
          joinStatus: currentState.team.joinStatus,
          members: currentState.team.members,
          memberCount: currentState.team.memberCount,
          quizCount: currentState.team.quizCount,
          quizzes: currentState.team.quizzes);

      updatedTeam.quizzes.addAll(quizzes);
      emit(GetTeamDetailSuccess(team: updatedTeam));
    }
  }

  onRemoveQuiz(BasicQuizEntity quiz) {
    if (state is GetTeamDetailSuccess) {
      final currentState = state as GetTeamDetailSuccess;
      var updatedTeam = TeamEntity(
          id: currentState.team.id,
          idHost: currentState.team.idHost,
          name: currentState.team.name,
          image: currentState.team.image,
          maxParticipant: currentState.team.maxParticipant,
          code: currentState.team.code,
          createdAt: currentState.team.createdAt,
          updatedAt: currentState.team.updatedAt,
          joinStatus: currentState.team.joinStatus,
          members: currentState.team.members,
          memberCount: currentState.team.memberCount,
          quizCount: currentState.team.quizCount,
          quizzes: currentState.team.quizzes);

      updatedTeam.quizzes.remove(quiz);
      emit(GetTeamDetailSuccess(team: updatedTeam));
    }
  }

  onSearchMember(String searchText) {
    if (state is GetTeamDetailSuccess) {
      final currentState = state as GetTeamDetailSuccess;
      List<TeamMemberEntity> filteredMembers = _allMembers
          .where((member) => member.member.email
          .toLowerCase()
          .contains(searchText.toLowerCase()))
          .toList();
      currentState.team.members=filteredMembers;
      emit(GetTeamDetailSuccess(
        team: currentState.team,
      ));
    }
  }
}
