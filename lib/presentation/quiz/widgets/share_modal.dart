import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/data/post/models/post_payload_model.dart';
import 'package:quiz_app/domain/post/usecase/add_post_usecase.dart';
import 'package:quiz_app/domain/team/usecase/get_list_team_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_friend_usecase.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_cubit.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_state.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_cubit.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_state.dart';

class ShareModal extends StatefulWidget {
  final String quizId;

  const ShareModal({super.key, required this.quizId});

  @override
  _ShareModalState createState() => _ShareModalState();
}

class _ShareModalState extends State<ShareModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => GetTeamCubit()
              ..onGet(usecase: GetListTeamUseCase(), params: 'myTeam=true')),
        BlocProvider(
            create: (_) => GetFriendCubit()
              ..onGet(useCase: GetFriendUseCase(), params: '')),
        BlocProvider(create: (_) => ButtonStateCubit())
      ],
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (BuildContext context, ButtonState state) {
          if (state is ButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: GetFailure(name: state.errorMessage)));
          }
          if (state is ButtonSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(
              child: Text("share quiz to team success"),
            )));
            Navigator.of(context).pop();
          }
        },
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Share with",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Team"),
                  Tab(text: "Friend"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_listTeam(), _listFriend()],
                ),
              ),
              SizedBox(
                height: 100,
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: _tabController.index == 0
                        ? 'Enter content'
                        : 'Enter message',
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _listTeam() {
    return BlocBuilder<GetTeamCubit, GetTeamState>(
      builder: (BuildContext context, GetTeamState state) {
        if (state is GetTeamLoading) {
          return const GetLoading();
        }
        if (state is GetTeamFailure) {
          return GetFailure(name: state.error);
        }
        if (state is GetTeamSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.teams.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Base64ImageWidget(
                        base64String: state.teams[index].image,
                      ),
                    ),
                  ),
                  title: Text(state.teams[index].name),
                  trailing: Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            context.read<ButtonStateCubit>().execute(
                                usecase: AddPostUseCase(),
                                params: PostPayloadModel(
                                    content: _contentController.text,
                                    team: state.teams[index].id,
                                    image: '',
                                    quiz: widget.quizId));
                          },
                          icon: const Icon(CupertinoIcons.share));
                    }
                  ));
            },
          );
        }
        return const GetSomethingWrong();
      },
    );
  }

  Widget _listFriend() {
    return BlocBuilder<GetFriendCubit, GetFriendState>(
      builder: (BuildContext context, GetFriendState state) {
        if (state is GetFriendLoading) {
          return const GetLoading();
        }
        if (state is GetFriendFailure) {
          return GetFailure(name: state.error);
        }
        if (state is GetFriendSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Base64ImageWidget(
                        base64String: state.users[index].avatar,
                      ),
                    ),
                  ),
                  title: Text(state.users[index].email),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.share)));
            },
          );
        }
        return const GetSomethingWrong();
      },
    );
  }
}
