import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/team/get_joined_status_cubit.dart';
import 'package:quiz_app/common/widgets/build_avatar.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/domain/team/entity/join_request_entity.dart';

import '../../../domain/team/usecase/delete_request_join_team_usecase.dart';

class RequestJoinModal extends StatefulWidget {
  final List<JoinRequestEntity> requests;
  final VoidCallback onRefresh;
  final BuildContext parentContext;
  const RequestJoinModal(
      {super.key, required this.requests, required this.onRefresh, required this.parentContext});

  @override
  State<RequestJoinModal> createState() => _RequestJoinModalState();
}

class _RequestJoinModalState extends State<RequestJoinModal> {
  late int removeIndex;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return BlocProvider(
          create: (BuildContext context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (BuildContext context, ButtonState state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (state is ButtonFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: GetFailure(name: state.errorMessage)));
              }
              if (state is ButtonSuccessState) {
                widget.parentContext.read<GetJoinedStatusCubit>().onRemoveStatusCode(removeIndex);
                setState(() {

                });

              }
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Join Requests",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (widget.requests.isEmpty)
                    const Text("No join requests available."),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.requests.length,
                    itemBuilder: (context, index) {
                      JoinRequestEntity request = widget.requests[index];
                      return ListTile(
                        leading: buildAvatar(request.idTeam.image),
                        title: Text(request.idTeam.name),
                        subtitle: Text("Status: ${request.status}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              request.status == 'approved'
                                  ? Icons.check_circle
                                  : request.status == 'rejected'
                                      ? Icons.cancel
                                      : Icons.hourglass_empty,
                              color: request.status == 'approved'
                                  ? Colors.green
                                  : request.status == 'rejected'
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context.read<ButtonStateCubit>().execute(
                                    usecase: DeleteRequestJoinTeamUseCase(),
                                    params: request.idTeam.id);
                                setState((){
                                  removeIndex=index;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
