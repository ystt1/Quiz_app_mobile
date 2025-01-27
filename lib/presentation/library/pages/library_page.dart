import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/add_question_modal.dart';
import 'package:quiz_app/common/widgets/add_quiz_modal.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/question_card.dart';
import 'package:quiz_app/common/widgets/search_sort.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_question_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_question_state.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_quiz_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_quiz_state.dart';
import 'package:quiz_app/presentation/library/widget/question_detail.dart';
import 'package:quiz_app/presentation/library/widget/quiz_list.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _selectedTabIndex = 0;

  void onRefreshQuestion(BuildContext context) {
    context.read<GetMyQuestionCubit>().onGet(SearchAndSortModel(name: '', sortField: '', direction: ''));
  }

  void onRefreshQuiz(BuildContext context) {
    context
        .read<GetMyQuizCubit>()
        .onGet(SearchAndSortModel(name: '', sortField: '', direction: ''));
  }

  void onGetQuiz(BuildContext context, SearchAndSortModel searchSort) {
    context.read<GetMyQuizCubit>().onGet(searchSort);
  }

  void onGetQuestion(BuildContext context, SearchAndSortModel searchSort) {
    context.read<GetMyQuestionCubit>().onGet(searchSort);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => GetMyQuizCubit()
              ..onGet(
                  SearchAndSortModel(name: '', sortField: '', direction: ''))),
        BlocProvider(
            create: (BuildContext context) => GetMyQuestionCubit()..onGet(SearchAndSortModel(name: '', sortField: '', direction: ''))),
      ],
      child: Scaffold(
        body: BlocBuilder<GetMyQuizCubit, GetMyQuizState>(
          builder: (BuildContext context, quizzes) {
            return BlocBuilder<GetMyQuestionCubit, GetMyQuestionState>(
              builder: (BuildContext context, GetMyQuestionState questions) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTabButton('Quiz', 0),
                          _buildTabButton('Question', 1),
                        ],
                      ),
                    ),
                    SearchSort(
                      onSearch: (state) {
                        _selectedTabIndex == 0?
                          onGetQuiz(context, state):onGetQuestion(context, state);

                      },
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _selectedTabIndex == 0
                              ? _buildQuizList(quizzes)
                              : _buildQuestionList(questions),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (innerContext) => _selectedTabIndex == 1
                    ? AddQuestionModal(
                        onRefresh: () => onRefreshQuestion(context))
                    : AddQuizModal(onRefresh: () => onRefreshQuiz(context)),
              );
            },
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add, size: 28),
          );
        }),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizList(quizzes) {
    if (quizzes is GetMyQuizLoading) {
      return const GetLoading();
    }
    if (quizzes is GetMyQuizFailure) {
      return GetFailure(name: quizzes.error);
    }
    if (quizzes is GetMyQuizSuccess) {
      return QuizList(
          quizList: quizzes.myQuiz,
          isYour: true,
          onRefresh: () => onRefreshQuiz(context));
    }
    return GetSomethingWrong();
  }

  Widget _buildQuestionList(questions) {

      if (questions is GetMyQuestionLoading) {
        return const GetLoading();
      }
      if (questions is GetMyQuestionFailure) {
        return GetFailure(name: questions.error);
      }
      if (questions is GetMyQuestionSuccess) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (innerContext) => EditQuestionModal(
                      question: questions.questions[index],
                      onRefresh: () => onRefreshQuestion(context)),
                );
              },
              child: QuestionCard(
                  question: questions.questions[index],
                  index: index,
                  onDelete: () {}),
            );
          },
          itemCount: questions.questions.length,
        );
      }
      return const GetSomethingWrong();
    }

}
