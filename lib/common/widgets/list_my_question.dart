

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/question_card.dart';
import 'package:quiz_app/data/quiz/models/quiz_quetion_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/add_question_to_quiz_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/select_question_cubit.dart';

import '../../presentation/library/bloc/get_my_question_cubit.dart';
import '../../presentation/library/bloc/get_my_question_state.dart';
import 'get_failure.dart';
import 'get_loading.dart';
import 'get_something_wrong.dart';

class ListMyQuestion extends StatefulWidget {
  final BasicQuizEntity quiz;
  final VoidCallback? onRefresh;
  const ListMyQuestion({super.key, required this.quiz, this.onRefresh});

  @override
  State<ListMyQuestion> createState() => _ListMyQuestionState();
}

class _ListMyQuestionState extends State<ListMyQuestion> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => GetMyQuestionCubit()..onGet()),
        BlocProvider(create: (BuildContext context) => SelectQuestionCubit()),
        BlocProvider(create: (BuildContext context) => ButtonStateCubit()),
      ],
      child: BlocBuilder<GetMyQuestionCubit, GetMyQuestionState>(
          builder: (BuildContext context, state) {
        if (state is GetMyQuestionLoading) {
          return const GetLoading();
        }
        if (state is GetMyQuestionFailure) {
          return GetFailure(name: state.error);
        }
        if (state is GetMyQuestionSuccess) {
          return BlocListener<ButtonStateCubit, ButtonState>(
            listener: (BuildContext context, ButtonState buttonState) {
              if (buttonState is ButtonLoadingState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: GetLoading()));
              }
              if (buttonState is ButtonSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Center(
                  child: Text("success"),
                )));
                context.read<SelectQuestionCubit>().onClear();
                widget.onRefresh?.call();
                Navigator.of(context).pop();
              }
              if (buttonState is ButtonFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: GetFailure(name: buttonState.errorMessage)));
              }
            },
            child: BlocBuilder<SelectQuestionCubit, List<String>>(
              builder: (BuildContext context, List<String> state2) {
                List<BasicQuestionEntity> questionList = state.questions;
                questionList.removeWhere((e) => widget.quiz.questions.any((ques) => ques.id == e.id));
                return _screen(context, questionList, state2);
              },
            ),
          );
        }
        return const GetSomethingWrong();
      }),
    );
  }

  Widget _screen(BuildContext context, List<BasicQuestionEntity> questions,
      List<String> selectedQuestion) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(CupertinoIcons.arrow_left)),
        title: Visibility(child: Text("${selectedQuestion.length} items")),
        actions: [
          Visibility(
            visible: selectedQuestion.isNotEmpty,
            child: IconButton(
                onPressed: () {
                  context.read<SelectQuestionCubit>().onClear();
                },
                icon: const Icon(
                  Icons.cancel,
                )),
          ),
          Visibility(
            visible: selectedQuestion.isNotEmpty,
            child: IconButton(
                onPressed: () {
                  context.read<ButtonStateCubit>().execute(
                      usecase: AddQuestionToQuizUseCase(),
                      params: QuizQuestionPayload(
                          quizId: widget.quiz.id, question: selectedQuestion));
                },
                icon: const Icon(
                  CupertinoIcons.add_circled_solid,
                  color: Colors.red,
                )),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {

          return GestureDetector(
            onTap: () {
              final questionId = questions[index].id;
              context.read<SelectQuestionCubit>().onSelect(questionId);
            },
            child: QuestionCard(
              question: questions[index],
              index: index,
              onDelete: () {},
              isSelectedMode: true,
              isSelected: selectedQuestion.contains(questions[index].id),
            ),
          );
        },
        itemCount: questions.length,
      ),
    );
  }
}
