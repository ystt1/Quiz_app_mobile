import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/common/widgets/add_question_modal.dart';
import 'package:quiz_app/common/widgets/add_quiz_modal.dart';
import 'package:quiz_app/common/widgets/center_text.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/question_card.dart';
import 'package:quiz_app/common/widgets/search_sort.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/domain/question/usecase/delete_question_usecase.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/get_list_my_quiz_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_question_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_question_state.dart';
import 'package:quiz_app/presentation/library/widget/question_detail.dart';
import 'package:quiz_app/presentation/library/widget/quiz_list.dart';

import '../../../core/constant/app_color.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _selectedTabIndex = 0;

  void onRefreshQuestion(BuildContext context) {
    context
        .read<GetMyQuestionCubit>()
        .onGet(SearchAndSortModel(name: '', sortField: '', direction: ''));
  }

  void onRefreshQuiz(BuildContext context) {
    context.read<GetListQuizCubit>().execute(
        usecase: GetListMyQuizUseCase(),
        params: SearchAndSortModel(name: '', sortField: '', direction: ''));
  }

  void onGetQuiz(BuildContext context, SearchAndSortModel searchSort) {
    context
        .read<GetListQuizCubit>()
        .execute(usecase: GetListMyQuizUseCase(), params: searchSort);
  }

  void onGetQuestion(BuildContext context, SearchAndSortModel searchSort) {
    context.read<GetMyQuestionCubit>().onGet(searchSort);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => GetListQuizCubit()
              ..execute(
                  usecase: GetListMyQuizUseCase(),
                  params: SearchAndSortModel(
                      name: '', sortField: '', direction: ''))),
        BlocProvider(
            create: (BuildContext context) => GetMyQuestionCubit()
              ..onGet(
                  SearchAndSortModel(name: '', sortField: '', direction: ''))),
      ],
      child: Scaffold(
        appBar:  PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(height: 40, ),
        ),
        body: BlocBuilder<GetListQuizCubit, GetListQuizState>(
          builder: (BuildContext context, quizzes) {
            return BlocBuilder<GetMyQuestionCubit, GetMyQuestionState>(
              builder: (BuildContext context, GetMyQuestionState questions) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blueAccent,
                            width: 3.0,
                          ),

                        ),
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
                        _selectedTabIndex == 0
                            ? onGetQuiz(context, state)
                            : onGetQuestion(context, state);
                      },
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _selectedTabIndex == 0
                              ? _buildQuizList(quizzes, context)
                              : _buildQuestionList(questions, context),
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
            heroTag: "create Library",
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
              color: isSelected ? AppColors.textColor : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.textColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizList(quizzes, BuildContext context) {
    if (quizzes is GetListQuizLoading) {
      return const GetLoading();
    }
    if (quizzes is GetListQuizFailure) {
      return GetFailure(name: quizzes.error);
    }
    if (quizzes is GetListQuizSuccess) {
      if(quizzes.quizzes.isEmpty)
        {
          return const CenterText(text: "Not found any quiz");
        }
      return BlocProvider(
        create: (BuildContext context) => ButtonStateCubit(),
        child: QuizList(
          quizList: quizzes.quizzes,
          isYour: true,
          onRefresh: () => onRefreshQuiz(context),
          type: 'delete',
        ),
      );
    }
    return const GetSomethingWrong();
  }

  Widget _buildQuestionList(questions, BuildContext context) {
    if (questions is GetMyQuestionLoading) {
      return const GetLoading();
    }
    if (questions is GetMyQuestionFailure) {
      return GetFailure(name: questions.error);
    }
    if (questions is GetMyQuestionSuccess) {
      if(questions.questions.isEmpty)
      {
        return const CenterText(text: "Not found any question");
      }
      return ListView.builder(
        itemBuilder: (context, index) {
          return BlocProvider(
            create: (BuildContext context) => ButtonStateCubit(),
            child: BlocListener<ButtonStateCubit, ButtonState>(
              listener: (BuildContext context, ButtonState btnState) {
                if (btnState is ButtonFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: GetFailure(name: btnState.errorMessage)));
                }
                if (btnState is ButtonSuccessState) {
                  context.read<GetMyQuestionCubit>().onRemove(btnState.index!);
                }
              },
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (innerContext) => EditQuestionModal(
                        parenContext: context,
                        question: questions.questions[index],
                        onRefresh: () => onRefreshQuestion(context)),
                  );
                },
                child: Builder(builder: (context) {
                  return QuestionCard(
                      question: questions.questions[index],
                      index: index,
                      onDelete: () {
                        context.read<ButtonStateCubit>().execute(
                            usecase: DeleteQuestionUseCase(),
                            params: questions.questions[index].id,
                            index: index);
                      });
                }),
              ),
            ),
          );
        },
        itemCount: questions.questions.length,
      );
    }
    return const GetSomethingWrong();
  }
}
