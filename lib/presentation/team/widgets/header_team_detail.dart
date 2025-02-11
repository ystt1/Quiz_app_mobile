import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_cubit.dart';
import 'package:quiz_app/common/widgets/build_avatar.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/data/team/model/request_payload_model.dart';
import 'package:quiz_app/domain/team/entity/join_request_entity.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/domain/team/usecase/host_change_status_usecase.dart';
import 'package:quiz_app/presentation/team/pages/team_setting_page.dart';

import '../../../common/bloc/team/get_joined_status_cubit.dart';
import '../../../common/bloc/team/get_joined_status_state.dart';
import '../../../common/widgets/get_failure.dart';
import '../../../common/widgets/get_loading.dart';

class HeaderTeamDetail extends StatelessWidget {
  final TeamEntity team;
  final VoidCallback onRefresh;

  const HeaderTeamDetail(
      {super.key, required this.team, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TeamSettingPage(
                      team: team,
                    )),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
             child: ClipRRect(borderRadius: BorderRadius.circular(60), child: Base64ImageWidget(base64String: team.image,)),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '${team.memberCount} members | Admin: ${team.idHost.email}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        Visibility(
          visible: (team.joinStatus == 'host'),
          child: BlocBuilder<GetJoinedStatusCubit, GetJoinedStatusState>(
            builder: (BuildContext context, GetJoinedStatusState state) {
              if (state is GetJoinedStatusLoading) {
                return const GetLoading();
              }
              if (state is GetJoinedStatusFailure) {
                return GetFailure(name: state.error);
              }
              if (state is GetJoinedStatusSuccess) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined,
                          color: Colors.black),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context2) => BlocProvider(
                            create: (context) => GetUserDetailCubit(),
                            child: _buildRequestList(context, state.requests),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            state.requests.length.toString(),
                            // Replace with dynamic count
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ],
                );
              }
              return const Placeholder();
            },
          ),
        )
      ],
    );
  }

  Widget _buildRequestList(
      BuildContext parentContext, List<JoinRequestEntity> requests) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Join Request',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return _buildRequestItem(request, parentContext,index,setState);
                  },
                ),
              ),
            ],
          ),
        );
      },

    );
  }

  Widget _buildRequestItem(JoinRequestEntity request, BuildContext parentContext,int index,void Function(void Function()) setState) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => ButtonStateCubit(),
          ),
        ],
        child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (BuildContext context, ButtonState btnState) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (btnState is ButtonLoadingState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: GetLoading()));
              }
              if (btnState is ButtonFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: GetFailure(name: btnState.errorMessage)));
              }
              if (btnState is ButtonSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: GetFailure(name: "success")));
                parentContext.read<GetJoinedStatusCubit>().onRemoveStatusCode(index);
                setState(() {});
                //onRefresh.call();
              }
            },
            child: ListTile(
              leading: CircleAvatar(
                child: ClipRRect(borderRadius: BorderRadius.circular(60),child: Base64ImageWidget(base64String:  request.idUser.avatar)),
              ),
              title: Text(
                request.idUser.email,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Gửi lúc: ${request.createdAt}',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Builder(
                builder: (context) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          context.read<ButtonStateCubit>().execute(
                              usecase: HostChangeStatusUseCase(),
                              params: RequestPayload(
                                  requestId: request.id, status: "approved"));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          context.read<ButtonStateCubit>().execute(
                              usecase: HostChangeStatusUseCase(),
                              params: RequestPayload(
                                  requestId: request.id, status: "rejected"));
                        },
                      ),
                    ],
                  );
                }
              ),
            )));
  }
}
