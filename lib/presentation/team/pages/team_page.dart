import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:quiz_app/common/bloc/team/get_joined_status_cubit.dart';
import 'package:quiz_app/common/bloc/team/get_joined_status_state.dart';

import 'package:quiz_app/common/widgets/add_team_modal.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/qr_page.dart';
import 'package:quiz_app/common/widgets/search_sort.dart';
import 'package:quiz_app/common/widgets/team_card.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/domain/team/entity/join_request_entity.dart';
import 'package:quiz_app/domain/team/usecase/get_list_team_usecase.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_cubit.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_state.dart';
import 'package:quiz_app/presentation/team/widgets/request_join_modal.dart';

class TeamPage extends StatefulWidget {
  final String? code;
  const TeamPage({super.key, this.code});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  void onRefresh(BuildContext context) {
    context.read<GetTeamCubit>().onGet(usecase: GetListTeamUseCase());
  }

  void onRefreshRequest(BuildContext context) {
    context.read<GetJoinedStatusCubit>().onGet("");
  }

  void onSearch(BuildContext context,SearchAndSortModel searchSort) {
    String params='';
    if(searchSort.name!="")
      {
        params+="name=${searchSort.name}&code=${searchSort.name}&";
      }
    if(searchSort.sortField!="")
    {
      params+="sortField=${searchSort.sortField}&sortOrder=${searchSort.direction}";
    }
    context.read<GetTeamCubit>().onGet(usecase: GetListTeamUseCase(),params: params);
  }

  void searchCode(BuildContext context, String code) {
    context.read<GetTeamCubit>().onGet(usecase: GetListTeamUseCase(), params: "code=$code");
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GetJoinedStatusCubit()..onGet("")),
          BlocProvider(
              create: (_) =>
                  GetTeamCubit()..onGet(usecase: GetListTeamUseCase(),params: "")),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Teams',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            actions: [
              BlocBuilder<GetJoinedStatusCubit, GetJoinedStatusState>(
                builder: (BuildContext context, GetJoinedStatusState state) {
                  if (state is GetJoinedStatusSuccess &&
                      state.requests.isNotEmpty) {
                    List<JoinRequestEntity> nonPendingRequests = state.requests
                        .where((e) => e.status != 'pending')
                        .toList();
                    if (nonPendingRequests.isNotEmpty) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notification_add),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context2) => RequestJoinModal(
                                  requests: nonPendingRequests,
                                  onRefresh: () {
                                    onRefreshRequest(context);
                                  }, parentContext: context,
                                ),
                              );
                            },
                            tooltip: 'Join Requests',
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                '${nonPendingRequests.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context2) => ScanQrPage(
                          onSearch: (code) {
                            searchCode(context, code);
                          },
                        )),
                      );
                    },
                    tooltip: 'Scan QR Code',
                  );
                }
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SearchSort(
                      onSearch: (state) {
                        onSearch(context, state);
                      },
                    ),
                  ),
                  BlocBuilder<GetTeamCubit, GetTeamState>(
                      builder: (BuildContext context, GetTeamState teams) {
                    if (teams is GetTeamLoading) {
                      return const GetLoading();
                    }
                    if (teams is GetTeamFailure) {
                      return GetFailure(name: teams.error);
                    }
                    if (teams is GetTeamSuccess) {
                      if (teams.teams.isEmpty) {
                        return const Center(
                          child: Text("Not Found Team"),
                        );
                      }
                      return Expanded(
                        child: ListView.separated(
                          itemCount: teams.teams.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return TeamCard(
                              team: teams.teams[index],
                              onRefresh: () {
                                onRefresh(context);
                              },
                            );
                          },
                        ),
                      );
                    }
                    ;
                    return const GetSomethingWrong();
                  }),
                ],
              );
            }
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  builder: (innerContext) {
                    return AddTeamModal(
                      onRefresh: () => onRefresh(context),
                    );
                  });
            },
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add),
            tooltip: 'Add New Team',
          ),
        ));
  }
}
