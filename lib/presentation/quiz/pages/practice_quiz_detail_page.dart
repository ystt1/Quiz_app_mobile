import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/comment_modal.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/get_hot_quiz_usecase.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_state.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_state.dart';
import 'package:quiz_app/presentation/quiz/pages/do_practice_page.dart';
import 'package:quiz_app/presentation/quiz/widgets/leader_board.dart';

import '../widgets/share_modal.dart';

class PracticeQuizDetailPage extends StatefulWidget {
  final String quizId;
  final String? teamId;
  const PracticeQuizDetailPage({super.key, required this.quizId, this.teamId});

  @override
  _PracticeQuizDetailPageState createState() => _PracticeQuizDetailPageState();
}

class _PracticeQuizDetailPageState extends State<PracticeQuizDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _showShareModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ShareModal(quizId: widget.quizId,);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 2) {
        _tabController.index = _tabController.previousIndex;
        _showCommentsModal();
      }
    });
  }

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return CommentModal(idQuiz: widget.quizId, context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              GetQuizDetailCubit()..onGet(widget.quizId),
        ),
        BlocProvider(create: (BuildContext context) => GetListQuizCubit()),
      ],
      child: DefaultTabController(
        length: 3,
        child: BlocBuilder<GetQuizDetailCubit, GetQuizDetailState>(
          builder: (BuildContext context, state) {
            if (state is GetQuizDetailLoading) {
              return GetLoading();
            }
            if (state is GetQuizDetailFailure) {
              return GetFailure(name: state.error);
            }
            if (state is GetQuizDetailSuccess) {
              context.read<GetListQuizCubit>().execute(
                  usecase: GetHotQuizUseCase(),
                  params: "idCreator=${state.quiz.idCreator}");
              return Scaffold(
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Stack(
                              children: [
                                Container(
                                    child: Base64ImageWidget(
                                  base64String: state.quiz.image,
                                )),
                                Container(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SafeArea(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back,
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share,
                                        color: Colors.white),
                                    onPressed: () => _showShareModal(context)
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Header Section
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Base64ImageWidget(
                                        base64String: state.quiz.image,
                                      )),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.quiz.name,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Questions: ${state.quiz.questionNumber}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'Duration: ${state.quiz.time} min',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PracticePage(quiz: state.quiz)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Start Quiz',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // TabBar Section
                          Container(
                            color: Colors.white,
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: Colors.blue,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.grey,
                              tabs: const [
                                Tab(text: 'Introduction'),
                                Tab(text: 'Leaderboard'),
                                Tab(text: 'Comments'),
                              ],
                            ),
                          ),
                          // TabBar View
                          Container(
                            height: MediaQuery.of(context).size.height - 300,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Introduction Tab
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8.0),
                                      const Text(
                                        'Description:',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(state.quiz.description),
                                      const SizedBox(height: 8.0),
                                      const Text(
                                        'Topics:',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Wrap(
                                        children: [
                                          ...state.quiz.topicId
                                              .map((e) =>
                                                  Chip(label: Text(e.name)))
                                              .toList(),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Text(
                                        'Other Quizzes by Owner:',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      BlocBuilder<GetListQuizCubit,
                                          GetListQuizState>(
                                        builder: (BuildContext context,
                                            GetListQuizState state) {
                                          if (state is GetListQuizLoading) {
                                            return GetLoading();
                                          }
                                          if (state is GetListQuizFailure) {
                                            return GetFailure(
                                                name: state.error);
                                          }
                                          if (state is GetListQuizSuccess) {
                                            return SizedBox(
                                              height: 210,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: (){Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (context) => PracticeQuizDetailPage(quizId: state.quizzes[index].id,)),
                                                    );},
                                                    child: Container(
                                                      width: 150,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 16.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      ),
                                                      child: Base64ImageWidget(
                                                        base64String: state
                                                            .quizzes[index].image,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: state.quizzes.length,
                                              ),
                                            );
                                          }
                                          return GetSomethingWrong();
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Leaderboard Tab
                                LeaderBoard(quiz: state.quiz),

                                Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return GetSomethingWrong();
          },
        ),
      ),
    );
  }
}
