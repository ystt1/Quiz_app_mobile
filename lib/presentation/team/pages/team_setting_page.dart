import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/click_user_detail.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/quiz_card.dart';
import 'package:quiz_app/data/team/model/kick_team_payload_model.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/domain/team/entity/team_member_entity.dart';
import 'package:quiz_app/domain/team/usecase/get_team_detail_usecase.dart';
import 'package:quiz_app/domain/team/usecase/kick_participant_usecase.dart';
import 'package:quiz_app/domain/team/usecase/leave_team_usecase.dart';
import 'package:quiz_app/presentation/home/pages/home_page.dart';
import 'package:quiz_app/presentation/quiz/pages/practice_quiz_detail_page.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_detail_cubit.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_detail_state.dart';
import 'package:quiz_app/presentation/team/pages/user_detail_modal.dart';
import 'package:quiz_app/presentation/team/widgets/add_quiz_to_team_modal.dart';

class TeamSettingPage extends StatefulWidget {
  final TeamEntity team;

  const TeamSettingPage({
    super.key,
    required this.team,
  });

  @override
  State<TeamSettingPage> createState() => _TeamSettingPageState();
}

class _TeamSettingPageState extends State<TeamSettingPage> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => GetTeamDetailCubit()
                ..onGet(usecase: GetTeamDetailUseCase(), params: widget.team.id))
        ],
        child: Column(
          children: [
            _buildTeamInfo(),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Participants'),
                        Tab(text: 'Quiz'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildMemberTab(context),
                          _buildQuizTab(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildLeaveOrDeleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfo() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          child: Base64ImageWidget(
            base64String: widget.team.image,
          ),
        ),
        Text('Participant: ${widget.team.members.length}/${widget.team.maxParticipant}'),
        Text('Team Code: ${widget.team.code}'),
        QrImageView(
          data: widget.team.code,
          size: 100,
        ),
      ],
    );
  }

  Widget _buildMemberTab(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ButtonStateCubit(),
      child: BlocBuilder<GetTeamDetailCubit, GetTeamDetailState>(
          builder: (BuildContext context, GetTeamDetailState teamState) {
        if (teamState is GetTeamDetailLoading) {
          return const GetLoading();
        }
        if (teamState is GetTeamDetailFailure) {
          return GetFailure(name: teamState.error);
        }
        if (teamState is GetTeamDetailSuccess) {
          return Column(
            children: [
               Padding(
                padding: const EdgeInsets.all(8.0),

                child: TextField(
                  onChanged: (value) {
                    context.read<GetTeamDetailCubit>().onSearchMember(value);
                  },
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Finding member',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: teamState.team.members.length,
                  itemBuilder: (context, index) {
                    return _buildMemberCard(
                        context, teamState.team.members[index]);
                  },
                ),
              )
            ],
          );
        }
        return const GetSomethingWrong();
      }),
    );
  }

  Widget _buildMemberCard(BuildContext context, TeamMemberEntity member) {
    return Card(
        child: BlocListener<ButtonStateCubit, ButtonState>(
      listener: (BuildContext context, ButtonState state) {
        if (state is ButtonFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: GetFailure(name: state.errorMessage)));
        }
        if (state is ButtonSuccessState) {
          context.read<GetTeamDetailCubit>().onKickUser(member);
        }
      },
      child: Builder(builder: (context) {
        return ListTile(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        UserModalPage(userId: member.member.id)),
              );
            },
            child: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Base64ImageWidget(
                  base64String: member.member.avatar,
                ),
              ),
            ),
          ),
          title: GestureDetector(
              onTap: () {
                onClickUser(context, member.member.id);
              },
              child: Text(member.member.email)),
          trailing: widget.team.joinStatus == 'host'
              ? IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () {
                    if (widget.team.joinStatus == 'host') {
                      context.read<ButtonStateCubit>().execute(
                          usecase: KickParticipantUseCase(),
                          params: KickTeamPayLoadModel(
                              teamId: widget.team.id, kickUser: member.member.id));
                    }
                  },
                )
              : null,
        );
      }),
    ));
  }

  Widget _buildLeaveOrDeleteButton(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (BuildContext context, state) {
          if (state is ButtonLoadingState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: GetLoading()));
          }
          if (state is ButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: GetFailure(name: state.errorMessage)));
          }
          if (state is ButtonSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: GetFailure(name: "success")));
            if (widget.team.joinStatus != 'host') {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          }
        },
        child: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () {
              if (widget.team.joinStatus != 'host') {
                context
                    .read<ButtonStateCubit>()
                    .execute(usecase: LeaveTeamUseCase(), params: widget.team.id);
              }
            },
            child: Text(widget.team.joinStatus == 'host' ? 'Xóa Team' : 'Rời Team'),
          );
        }),
      ),
    );
  }

  Widget _buildQuizTab(BuildContext context) {
    return BlocBuilder<GetTeamDetailCubit, GetTeamDetailState>(
      builder: (BuildContext context, state) {
        if (state is GetTeamDetailLoading) {
          return const GetLoading();
        }
        if (state is GetTeamDetailFailure) {
          return GetFailure(name: state.error);
        }
        if (state is GetTeamDetailSuccess) {

          return Column(children: [
            Row(children: [
              widget.team.joinStatus=='host'? IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context2) =>
                            _addQuizToTeamModal(state.team.quizzes, context));
                  },
                  icon: const Icon(Icons.add)):const SizedBox()
            ]),
            BlocProvider(
              create: (BuildContext context) => ButtonStateCubit(),
              child: BlocListener<ButtonStateCubit, ButtonState>(
                listener: (BuildContext context, ButtonState state) {
                  if (state is ButtonFailureState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: GetFailure(name: state.errorMessage)));
                  }
                  if (state is ButtonSuccessState) {
                    context.read<GetTeamDetailCubit>().onGet(
                        usecase: GetTeamDetailUseCase(), params: widget.team.id);
                  }
                },
                child: Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, index) {
                      return QuizCard(
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PracticeQuizDetailPage(
                              quizId: state.team.quizzes[index].id,
                            ),
                          ));
                        },
                        isYour: false,
                        quiz: state.team.quizzes[index],
                        type:widget.team.joinStatus=="host"? "removeFromTeam":"null",
                        idTeam: widget.team.id,
                      );
                    },
                    itemCount: state.team.quizzes.length,
                  ),
                ),
              ),
            )
          ]);
        }
        return const GetSomethingWrong();
      },
    );
  }

  _addQuizToTeamModal(
      List<BasicQuizEntity> existQuizzes, BuildContext context) {
    return AddQuizToTeamModal(
      team: widget.team,
      existQuizzes: existQuizzes,
      parentContext: context,
    );
  }
}
