import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/domain/team/usecase/add_request_join_team_usecase.dart';
import 'package:quiz_app/domain/team/usecase/delete_request_join_team_usecase.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_cubit.dart';
import 'package:quiz_app/presentation/team/pages/team_detail_page.dart';

class TeamCard extends StatelessWidget {
  final TeamEntity team;
  final VoidCallback onRefresh;
  const TeamCard({super.key, required this.team, required this.onRefresh});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (team.joinStatus == "joined"||team.joinStatus == "host") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamDetailPage(team: team),
            ),
          );
        }
      },
      child: BlocProvider(
        create: (BuildContext context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (BuildContext context, state) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (state is ButtonLoadingState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: GetLoading()));
            }
            if (state is ButtonFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: GetFailure(name: state.errorMessage)));
            }
            if (state is ButtonSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(
                  child: Text("success"),
                ),
              ));
              if(state.type=="join")
                {
                  context.read<GetTeamCubit>().onChangeStatus("pending", team);
                }
              if(state.type=="cancel")
              {
                context.read<GetTeamCubit>().onChangeStatus("not-joined", team);
              }
            }
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),

                    ),
                    child: Base64ImageWidget(base64String: team.image,),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${team.memberCount} members',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Owner: ${team.idHost.email}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (team.joinStatus == 'not-joined')
                    Builder(builder: (context) {
                      return _buildActionButton(context, 'Join', Colors.blue,
                          () {
                        _showJoinDialog(context, team);
                      });
                    })
                  else if (team.joinStatus == 'pending')
                    Builder(
                      builder: (context) {
                        return _buildActionButton(context, 'Cancel', Colors.orange, () {
                          context.read<ButtonStateCubit>().execute(
                              usecase: DeleteRequestJoinTeamUseCase(), params: team.id,type: "cancel");
                        });
                      }
                    )
                  else if(team.joinStatus=="joined" || team.joinStatus=="host" )
                      _buildActionButton(context, 'Access', Colors.green, () {
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 40,
      width: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  void _showJoinDialog(BuildContext context, TeamEntity team) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: Text('Join ${team.name}?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Owner: ${team.idHost}'),
              Text('Max Members: ${team.maxParticipant}'),
              Text('Created At: ${team.createdAt}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context2),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ButtonStateCubit>().execute(
                    usecase: AddRequestJoinTeamUseCase(), params: team.id,type: 'join');
                Navigator.of(context2).pop();
              },
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }
}
