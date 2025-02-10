import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/presentation/quiz/bloc/change_result_cubit.dart';
import 'package:quiz_app/presentation/quiz/bloc/get_practice_cubit.dart';
import 'package:quiz_app/presentation/quiz/bloc/get_pratice_state.dart';
import 'package:quiz_app/presentation/quiz/bloc/submit_cubit.dart';
import 'package:quiz_app/presentation/quiz/bloc/submit_state.dart';
import 'package:quiz_app/presentation/history/pages/result_page.dart';
import 'package:quiz_app/presentation/quiz/widgets/constructed.dart';
import 'package:quiz_app/presentation/quiz/widgets/drag_and_drop.dart';
import 'package:quiz_app/presentation/quiz/widgets/fill_in_the_blank.dart';
import 'package:quiz_app/presentation/quiz/widgets/selected_many.dart';
import 'package:quiz_app/presentation/quiz/widgets/selected_one.dart';
import 'dart:async';

import '../bloc/timer_cubit.dart';
import '../bloc/timer_state.dart';

class PracticePage extends StatefulWidget {
  final BasicQuizEntity quiz;

  const PracticePage({super.key, required this.quiz});

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  void onChangedResult(BuildContext context, state) {
    context.read<ChangeResultCubit>().updateAnswer(state);
  }

  List<List<String>> initializeUserAnswers(
      List<BasicQuestionEntity> questions) {
    return questions.map((question) {
      if (question.type == "drag-and-drop") {
        int blanksCount = question.content.split('___').length - 1;
        return List.generate(blanksCount, (_) => "");
      }
      return [""];
    }).toList();
  }

  Future<bool> onExitAttempt(
      BuildContext oldcontext, PracticePayloadModel result) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Exit"),
          content: const Text(
              "Are you sure you want to exit? Your answers will not save."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // submitAnswers(result, "pending", oldcontext);
                Navigator.of(context).pop(true);
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
    return shouldExit ?? false;
  }

  void submitAnswers(
      PracticePayloadModel result, String status, BuildContext context) async {
    final unansweredQuestions = result.userAnswers
        .asMap()
        .entries
        .where((entry) => entry.value.isEmpty || entry.value.contains(""))
        .map((entry) => entry.key + 1)
        .toList();

    if (unansweredQuestions.isNotEmpty && status == "done") {
      final confirmSubmit = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Not answer question"),
            content: Text(
                "You still have (question ${unansweredQuestions.join(", ")}) not answer yet. Are you sure want to submit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Back"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Submit"),
              ),
            ],
          );
        },
      );

      if (confirmSubmit != true) {
        return;
      }
    }

    final elapsedTime = context.read<WorkoutCubit>().state is WorkoutInProgress
        ? (context.read<WorkoutCubit>().state as WorkoutInProgress).elapsed!
        : 0;

    final flag = PracticePayloadModel(
      userAnswers: result.userAnswers,
      status: status,
      completeTime: widget.quiz.time - elapsedTime,
      quizId: result.quizId,
      questions: result.questions,
    );
    context.read<SubmitCubit>().onSubmit(flag);
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              GetPracticeQuestionCubit()..onGet(widget.quiz.id),
        ),
        BlocProvider(
          create: (context) => WorkoutCubit(),
        ),
        BlocProvider(
          create: (context) => SubmitCubit(),
        ),
      ],
      child: BlocListener<SubmitCubit, SubmitState>(
        listener: (BuildContext context, SubmitState buttonState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (buttonState is SubmitLoading) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: GetLoading()));
          }
          if (buttonState is SubmitFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: GetFailure(name: buttonState.error)));
          }
          if (buttonState is SubmitSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  result: buttonState.result,
                ),
              ),
            );
          }
        },
        child: BlocBuilder<GetPracticeQuestionCubit, GetPracticeQuestionState>(
          builder: (BuildContext context, GetPracticeQuestionState state) {
            if (state is GetPracticeQuestionLoading) {
              return GetLoading();
            }
            if (state is GetPracticeQuestionFailure) {
              return GetFailure(name: state.error);
            }
            if (state is GetPracticeQuestionSuccess) {
              BlocProvider.of<WorkoutCubit>(context)
                  .startWorkout(widget.quiz.time);
              List<String> ques = state.questions.map((e) => e.id).toList();
              return BlocProvider(
                create: (BuildContext context) => ChangeResultCubit(
                  PracticePayloadModel(
                    questions: ques,
                    userAnswers: initializeUserAnswers(state.questions),
                    status: "pending",
                    completeTime: widget.quiz.time,
                    quizId: widget.quiz.id,
                  ),
                ),
                child: BlocBuilder<ChangeResultCubit, PracticePayloadModel>(
                  builder: (BuildContext context, PracticePayloadModel result) {
                    return WillPopScope(
                      onWillPop: () => onExitAttempt(context, result),
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text(widget.quiz.name),
                        ),
                        body: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocConsumer<WorkoutCubit, WorkoutState>(
                                builder:
                                    (BuildContext context, WorkoutState time) {
                                  if (time is WorkoutInProgress) {
                                    return Text(
                                      "Time Left: ${formatTime(time.elapsed!)}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                  return Container();
                                },
                                listener: (context, state) {
                                  if (state is WorkoutFinish) {
                                    final result =
                                        context.read<ChangeResultCubit>().state;
                                    submitAnswers(result, "done", context);
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.questions.length,
                                itemBuilder: (context, index) {
                                  final question = state.questions[index];
                                  return Card(
                                    margin: const EdgeInsets.all(8.0),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: buildQuestion(
                                          question, index, context, result),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () =>
                                    submitAnswers(result, "done", context),
                                child: const Text("Submit"),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const GetSomethingWrong();
          },
        ),
      ),
    );
  }

  Widget buildQuestion(BasicQuestionEntity question, int index,
      BuildContext context, PracticePayloadModel result) {
    Widget questionWidget;
    switch (question.type) {
      case 'selected-one':
        questionWidget = SelectedOne(
          question: question,
          onChange: (PracticePayloadModel result) {
            onChangedResult(context, result);
          },
          result: result,
          index: index,
        );
        break;
      case 'selected-many':
        questionWidget = SelectedMany(
          question: question,
          onChange: (PracticePayloadModel result) {
            onChangedResult(context, result);
          },
          result: result,
          index: index,
        );
        break;
      case 'constructed':
        questionWidget = Constructed(
          question: question,
          onChange: (PracticePayloadModel result) {
            onChangedResult(context, result);
          },
          result: result,
          index: index,
        );
        break;
      case 'fill-in-the-blank':
        questionWidget = FillInTheBlank(
          question: question,
          onChange: (PracticePayloadModel result) {
            onChangedResult(context, result);
          },
          result: result,
          index: index,
        );
        break;
      case 'drag-and-drop':
        questionWidget = DragAndDrop(
          question: question,
          onChange: (PracticePayloadModel result) {
            onChangedResult(context, result);
          },
          result: result,
          index: index,
        );
        break;
      default:
        questionWidget = const Text('Unsupported question type');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "${index + 1}. ${(question.type != 'fill-in-the-blank' && question.type != 'drag-and-drop') ? question.content : ''}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        questionWidget,
      ],
    );
  }

  String formatTime(int seconds) {
    return "${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}";
  }
}
