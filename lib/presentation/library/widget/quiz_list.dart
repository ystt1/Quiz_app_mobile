import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/quiz/quiz_selector_cubit.dart';
import 'package:quiz_app/common/widgets/quiz_card.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/presentation/quiz/pages/practice_quiz_detail_page.dart';
import '../pages/quiz_detail_page.dart';

class QuizList extends StatelessWidget {
  final List<BasicQuizEntity> quizList;
  final bool isYour;
  final VoidCallback? onRefresh;
  final bool canChoose;
  final String type;
  final String teamId;
  const QuizList(
      {super.key,
      required this.quizList,
      required this.isYour,
      this.onRefresh,
      this.canChoose = false,
      this.type="null" , this.teamId=""});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => QuizSelectorCubit(),
        ),
      ],
      child: BlocBuilder<QuizSelectorCubit, List<BasicQuizEntity>>(
        builder: (context, selectedQuiz) {
          final isSelectedMode = selectedQuiz.isNotEmpty;
          return ListView.separated(
            itemCount: quizList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final quiz = quizList[index];
              final isSelected = selectedQuiz.contains(quiz);

              return GestureDetector(
                onLongPress: () {
                  if (canChoose) {
                    context.read<QuizSelectorCubit>().onSelect(quiz);
                  }
                },
                child: QuizCard(
                  onClick: () {
                    if (canChoose && isSelectedMode) {
                      context.read<QuizSelectorCubit>().onSelect(quiz);
                      return;
                    }
                    if (isYour) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => QuizDetailPage(
                          quiz: quiz,
                          parentContext: context,
                          //onRefresh: onRefresh,
                        ),
                      ));
                    }
                    if (!isYour) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PracticeQuizDetailPage(
                          quizId: quiz.id,
                        ),
                      ));
                    }
                  },
                  isYour: isYour,
                  quiz: quiz,
                  isSelected: isSelected,
                  isSelectedMode: isSelectedMode,
                  type: type,
                  idTeam: teamId,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
