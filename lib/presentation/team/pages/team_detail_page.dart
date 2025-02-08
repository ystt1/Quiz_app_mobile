import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/team/get_joined_status_cubit.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_cubit.dart';

import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/presentation/team/bloc/get_list_post_cubit.dart';
import 'package:quiz_app/presentation/team/widgets/create_post_modal.dart';

import 'package:quiz_app/presentation/team/widgets/header_team_detail.dart';

import '../widgets/post_tab.dart';

class TeamDetailPage extends StatefulWidget {
  final TeamEntity team;

  const TeamDetailPage({super.key, required this.team});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  String _selectedSortBy = 'updatedAt';

  void _showPostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context2) => CreatePostModal(
        team: widget.team,
        onRefresh: ()=>onRefresh(context),
      ),
    );
  }
  void onRefresh(BuildContext context)
  {
    context.read<GetListPostCubit>().onGet(widget.team.id);
  }

  void onRefreshJoinRequest(BuildContext context) {
    context.read<GetJoinedStatusCubit>().onGet(widget.team.id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                GetJoinedStatusCubit()..onGet(widget.team.id)),
        BlocProvider(create: (BuildContext context) => GetUserDetailCubit()),
        BlocProvider(
          create: (BuildContext context) =>
              GetListPostCubit()..onGet("${widget.team.id}&sortBy=$_selectedSortBy"),
        )
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Builder(builder: (context) {
            return HeaderTeamDetail(
              team: widget.team,
              onRefresh: () => onRefreshJoinRequest(context),
            );
          }),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showPostModal(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'What\'s on your mind, You?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Builder(
                    builder: (context) {
                      return DropdownButton<String>(
                        value: _selectedSortBy,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSortBy = newValue!;
                            context.read<GetListPostCubit>().onGet("${widget.team.id}&sortBy=$_selectedSortBy");
                          });
                        },
                        items: const [
                          DropdownMenuItem(value: 'updatedAt', child: Text('Recently Updated')),
                          DropdownMenuItem(value: 'createdAt', child: Text('Newest First')),
                        ],
                      );
                    }
                  ),
                ],
              ),
            ),
            Expanded(
                child: PostTab(
              team: widget.team,
            )),
          ],
        ),
      ),
    );
  }
}
