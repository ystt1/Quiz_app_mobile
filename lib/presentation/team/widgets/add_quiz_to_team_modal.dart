import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/common/bloc/quiz/quiz_selector_cubit.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/data/team/model/put_team_quiz_payload.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/get_list_my_quiz_usecase.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/domain/team/usecase/add_quiz_to_team_usecase.dart';
import 'package:quiz_app/presentation/team/bloc/get_team_detail_cubit.dart';

import '../../../core/constant/app_color.dart';

class AddQuizToTeamModal extends StatelessWidget {
  final TeamEntity team;
  final List<BasicQuizEntity> existQuizzes;
  final BuildContext parentContext;
  const AddQuizToTeamModal(
      {super.key, required this.team, required this.existQuizzes, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => GetListQuizCubit()..execute(usecase: GetListMyQuizUseCase(),params:SearchAndSortModel(
        name: "", sortField: "", direction: "")) ),
          BlocProvider(
            create: (_) => QuizSelectorCubit(),
          ),
          BlocProvider(create: (_) => ButtonStateCubit()),
        ],
        child: Builder(builder: (context) {
          return BlocListener<ButtonStateCubit, ButtonState>(
            listener: (BuildContext context, ButtonState state) {
              if (state is ButtonSuccessState) {
                context
                    .read<GetListQuizCubit>()
                    .onRemoveQuiz(context.read<QuizSelectorCubit>().state);
                parentContext
                    .read<GetTeamDetailCubit>()
                    .onAddQuiz(context.read<QuizSelectorCubit>().state);
                context.read<QuizSelectorCubit>().onClear();
              }
              if (state is ButtonFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: GetFailure(name: state.errorMessage)));
              }
            },
            child: StatefulBuilder(builder: (context, setState) {
              return BlocBuilder<GetListQuizCubit, GetListQuizState>(
                builder: (BuildContext context, GetListQuizState state) {
                  if (state is GetListQuizLoading) {
                    return const GetLoading();
                  }
                  if (state is GetListQuizFailure) {
                    return GetFailure(name: state.error);
                  }
                  if (state is GetListQuizSuccess) {
                    List<BasicQuizEntity> quizList = state.quizzes;
                    quizList.removeWhere(
                        (quiz) => existQuizzes.any((e) => e.id == quiz.id));
                    return Container(
                      padding: EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(CupertinoIcons.xmark_circle))
                            ],
                          ),
                          Expanded(
                            child: _quizList(quizList, context),
                          )
                        ],
                      ),
                    );
                  }
                  return const GetSomethingWrong();
                },
              );
            }),
          );
        }));
  }

  Widget _quizList(quizList, BuildContext context) {
    return BlocBuilder<QuizSelectorCubit, List<BasicQuizEntity>>(
      builder: (context, selectedQuiz) {
        final isSelectedMode = selectedQuiz.isNotEmpty;
        return ListView.separated(
          itemCount: quizList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final quiz = quizList[index];
            final isSelected = selectedQuiz.contains(quiz);
            return GestureDetector(
                onLongPress: () =>
                    context.read<QuizSelectorCubit>().onSelect(quiz),
                onTap: () {
                  if (isSelectedMode == true) {
                    context.read<QuizSelectorCubit>().onSelect(quiz);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(children: [
                    _image(quiz),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _nameAndMenu(
                                context, quiz, isSelectedMode, isSelected),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _information(Icons.timer, '${quiz.time} min'),
                                _information(Icons.help,
                                    '${quiz.questionNumber} question'),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            _information(Icons.date_range, quiz.createdAt),
                            const SizedBox(
                              height: 3,
                            ),
                            _tag(quiz),
                            const SizedBox(
                              height: 1.5,
                            ),
                            const Divider(height: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ));
          },
        );
      },
    );
  }

  Widget _image(BasicQuizEntity quiz) {
    return Container(
      width: 90,
      height: 105,
      decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 0.3)),
      child: Base64ImageWidget(base64String: quiz.image,),
    );
  }

  Widget _nameAndMenu(BuildContext context, BasicQuizEntity quiz,
      bool isSelectedMode, bool isSelected) {
    return Row(
      children: [
        Expanded(
          child: Text(
            quiz.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        isSelectedMode
            ? Checkbox(
                value: isSelected,
                onChanged: (value) {},
              )
            : (IconButton(
                onPressed: () {
                  context.read<QuizSelectorCubit>().onSelect(quiz);
                  context.read<ButtonStateCubit>().execute(
                      usecase: AddQuizToTeamUseCase(),
                      params: PutTeamQuizPayload(
                          idTeam: team.id, quizIds: [quiz.id]));
                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              )),
      ],
    );
  }

  Widget _tag(BasicQuizEntity quiz) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: quiz.topicId
            .map(
              (topic) => Container(
                child: Row(
                  children: [
                    const Icon(Icons.tag, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      topic.name,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _information(IconData icon, String property) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          property,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
