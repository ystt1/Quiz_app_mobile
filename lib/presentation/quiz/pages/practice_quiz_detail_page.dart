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
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_state.dart';
import 'package:quiz_app/presentation/quiz/pages/do_practice_page.dart';
import 'package:quiz_app/presentation/quiz/widgets/introduction.dart';
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
        return ShareModal(
          quizId: widget.quizId,
        );
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
        return CommentModal(idQuiz: widget.quizId, context: context,idTeam: widget.teamId,);
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
                body: Column(
                  children: [
                    _quizDetailHeader(state.quiz),

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
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Introduction(quiz: state.quiz),
                          LeaderBoard(quiz: state.quiz),
                          Container(),
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

  Widget _quizDetailHeader(BasicQuizEntity quiz) {
    return Stack(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: Stack(children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Base64ImageWidget(
                base64String: quiz.image,
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ]),
        ),
        Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () => _showShareModal(context)),
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Base64ImageWidget(
                          base64String: quiz.image,
                        )),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Questions: ${quiz.questionNumber}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Duration: ${quiz.time} min',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => PracticePage(quiz: quiz)),
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
            ),
          ],
        ),
      ],
    );
  }
}
