import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/profile/get_profile_cubit.dart';
import 'package:quiz_app/common/bloc/profile/get_profile_state.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/common/widgets/build_avatar.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/click_user_detail.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/quiz_card.dart';
import 'package:quiz_app/domain/quiz/usecase/get_hot_quiz_usecase.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:quiz_app/domain/user/usecase/accept_friend_request_usecase.dart';
import 'package:quiz_app/domain/user/usecase/add_friend_usecase.dart';
import 'package:quiz_app/domain/user/usecase/cancel_friend_request_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_friend_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_user_detail_usecase.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_cubit.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_state.dart';
import 'package:quiz_app/presentation/friend/pages/chatting_page.dart';
import 'package:quiz_app/presentation/profile/page/profile_page.dart';
import 'package:quiz_app/presentation/quiz/pages/practice_quiz_detail_page.dart';

import '../../../common/bloc/result/get_list_quiz_cubit.dart';
import '../../../common/bloc/result/get_list_result_state.dart';
import '../../../core/global_storage.dart';
import '../../../domain/quiz/usecase/get_list_result_usecase.dart';
import '../../history/widgets/result_card.dart';

class UserModalPage extends StatelessWidget {
  final String userId;

  const UserModalPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GlobalStorage.getUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final id = snapshot.data ?? "";

        return userId == id
            ? ProfilePage()
            : MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (_) => GetProfileCubit()
                        ..onGet(
                            useCase: GetUserDetailUseCase(), params: userId)),
                  BlocProvider(create: (_) => ButtonStateCubit()),
                  BlocProvider(
                      create: (_) => GetFriendCubit()
                        ..onGet(useCase: GetFriendUseCase(), params: userId)),
                  BlocProvider(
                      create: (_) => GetListQuizCubit()
                        ..execute(
                            usecase: GetHotQuizUseCase(),
                            params: "idCreator=$userId&status=active")),
                  BlocProvider(
                    create: (BuildContext context) => GetListResultCubit()
                      ..execute(
                          usecase: GetListResultUseCase(),
                          params: 'idParticipant=$userId'),
                  )
                ],
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text("User Profile"),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsCard(),
                        const SizedBox(height: 20),
                        _buildFriendsList(context),
                        const SizedBox(height: 20),
                        _buildTabs(),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildStatsCard() {
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (BuildContext context, GetProfileState state) {
        if (state is GetProfileLoading) {
          return const GetLoading();
        }
        if (state is GetProfileFailure) {
          return GetFailure(name: state.error);
        }
        if (state is GetProfileSuccess) {
          return BlocListener<ButtonStateCubit, ButtonState>(
            listener: (BuildContext context, ButtonState btnState) {
              if (btnState is ButtonFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: GetFailure(name: btnState.errorMessage)));
              }
              if (btnState is ButtonSuccessState) {
                context.read<GetProfileCubit>().onChangeStatus();
              }
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                            height: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Base64ImageWidget(
                                base64String: state.user.avatar,
                              ),
                            )),
                        Text(state.user.email,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildStatRow(Icons.score, "Total Score",
                        state.user.totalScore.toString()),
                    _buildStatRow(Icons.help_outline, "Total Questions",
                        state.user.quizCount.toString()),
                    _buildStatRow(Icons.quiz, "Total Quizzes",
                        state.user.questionCount.toString()),
                    const SizedBox(height: 20),

                    // Hiển thị nút dựa trên trạng thái bạn bè
                    switch (state.user.friendshipStatus) {
                      'friends' => OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChattingPage(user: SimpleUserEntity(id: state.user.id, email: state.user.email, avatar: state.user.avatar))),
                            );
                          },
                          icon: const Icon(Icons.chat, color: Colors.blue),
                          label: const Text("Message"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      'none' => ElevatedButton.icon(
                          onPressed: () {
                            context.read<ButtonStateCubit>().execute(
                                usecase: AddFriendUseCase(),
                                params: state.user.id);
                          },
                          icon:
                              const Icon(Icons.person_add, color: Colors.white),
                          label: const Text("Add Friend"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      'request_sent' => OutlinedButton.icon(
                          onPressed: () {
                            context.read<ButtonStateCubit>().execute(
                                usecase: CancelFriendRequestUseCase(),
                                params: state.user.id);
                          },
                          icon: const Icon(Icons.cancel, color: Colors.orange),
                          label: const Text("Cancel Request"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange),
                          ),
                        ),
                      'request_received' => Wrap(
                          spacing: 10,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<ButtonStateCubit>().execute(
                                    usecase: AcceptFriendRequestUseCase(),
                                    params: state.user.id);
                              },
                              icon:
                                  const Icon(Icons.check, color: Colors.white),
                              label: const Text("Accept"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Từ chối lời mời
                              },
                              icon: const Icon(Icons.close, color: Colors.red),
                              label: const Text("Decline"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      'blocked' => const SizedBox(),
                      _ => const SizedBox(),
                    },
                  ],
                ),
              ),
            ),
          );
        }
        return const GetSomethingWrong();
      },
    );
  }

  Widget _buildStatRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Text("$title: $value", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    return BlocBuilder<GetFriendCubit, GetFriendState>(
      builder: (BuildContext context, GetFriendState state) {
        if (state is GetFriendLoading) {
          return const GetLoading();
        }
        if (state is GetFriendFailure) {
          return GetFailure(name: state.error);
        }
        if (state is GetFriendSuccess) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Friends (${state.users.length})",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: const Text("View All",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // GridView hiển thị bạn bè
                SizedBox(
                  height: state.users.length > 8 ? 100 : 200,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: state.users.length > 8 ? 8 : state.users.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          onClickUser(context, state.users[index].id);
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Base64ImageWidget(
                                    base64String: state.users[index].avatar),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.users[index].email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const GetSomethingWrong();
      },
    );
  }

  Widget _buildTabs() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.history), text: "Recent Activities"),
              Tab(icon: Icon(Icons.create), text: "My Quizzes"),
            ],
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                BlocBuilder<GetListResultCubit, GetListResultState>(
                    builder: (BuildContext context, GetListResultState state) {
                  if (state is GetListResultLoading) {
                    return const GetLoading();
                  }
                  if (state is GetListResultFailure) {
                    return GetFailure(name: state.error);
                  }
                  if (state is GetListResultSuccess) {
                    if (state.results.isEmpty) {
                      return Center(child: Text("Not found any history"));
                    }
                    return
                       ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: state.results.length,
                        itemBuilder: (context, index) {
                          final result = state.results[index];
                          return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PracticeQuizDetailPage(
                                                quizId: result.quizId.id)),
                                  ),
                              child: ResultCard(result: result));
                        },

                    );
                  }
                  return const GetSomethingWrong();
                }),
                BlocBuilder<GetListQuizCubit, GetListQuizState>(
                  builder: (BuildContext context, GetListQuizState state) {
                    if (state is GetListQuizLoading) {
                      return GetLoading();
                    }
                    if (state is GetListQuizFailure) {
                      return GetFailure(name: state.error);
                    }
                    if (state is GetListQuizSuccess) {
                      return ListView.builder(
                          itemCount: state.quizzes.length,
                          itemBuilder: (context, index) {
                            return QuizCard(
                                onClick: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PracticeQuizDetailPage(
                                                quizId:
                                                    state.quizzes[index].id)),
                                  );
                                },
                                isYour: false,
                                quiz: state.quizzes[index]);
                          });
                    }
                    return GetSomethingWrong();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
