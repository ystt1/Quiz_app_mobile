import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/core/constant/app_color.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/entity/result_entity.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_state.dart';
import 'package:quiz_app/presentation/quiz/pages/practice_quiz_detail_page.dart';

class ResultPage extends StatelessWidget {
  final ResultEntity result;

  const ResultPage({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GetQuizDetailCubit()..onGet(result.quizId.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(result.quizId.name),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResultSummary(context),
              const SizedBox(height: 20),
              const Text("Your Answers:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<GetQuizDetailCubit, GetQuizDetailState>(
                  builder: (BuildContext context, GetQuizDetailState state) {
                    if (state is GetQuizDetailLoading) {
                      return const GetLoading();
                    }
                    if (state is GetQuizDetailFailure) {
                      return GetFailure(name: state.error);
                    }
                    if (state is GetQuizDetailSuccess) {
                      return ListView.builder(
                        itemCount: state.quiz.questions.length,
                        itemBuilder: (context, index) {
                          return _buildAnswerCard(index, state.quiz);
                        },
                      );
                    }
                    return const GetSomethingWrong();
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PracticeQuizDetailPage(quizId: result.quizId.id)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Practice again", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultSummary(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quiz: ${result.quizId.name}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Score:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("${result.score}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(result.status, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Completion Time:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(AppHelper.formatDuration(result.completeTime), style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Attempts:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("${result.attemptTime}", style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(AppHelper.dateFormatWithTime(result.createdAt), style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard(int index, BasicQuizEntity quiz) {
    final question = quiz.questions[index];
    final userAnswers = result.userAnswers.length > index ? result.userAnswers[index] : [];
    final correctAnswers = question.answers.where((a) => a.isCorrect).map((a) => a.content).toList();

    bool isDragOrFill = question.type == 'drag-and-drop' || question.type == 'fill-in-the-blank';

    bool isCompletelyCorrect = isDragOrFill
        ? userAnswers.join('|') == correctAnswers.join('|')  // So sánh đúng thứ tự
        : correctAnswers.every((answer) => userAnswers.contains(answer)) && userAnswers.every((answer) => correctAnswers.contains(answer));

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isCompletelyCorrect ? AppColors.successColor : AppColors.errorColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text("${index + 1}. ${question.content}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...question.answers.map((answer) {
              bool isSelected = userAnswers.contains(answer.content);
              bool isCorrect = correctAnswers.contains(answer.content);
              bool isMissing = isCorrect && !isSelected;

              return Text(
                "- ${answer.content} ${isSelected ? (isCorrect ? '✔' : '✘') : ''}",
                style: TextStyle(
                  color: isSelected
                      ? (isCorrect ? AppColors.successColor : AppColors.errorColor) // Đúng: xanh, Sai: đỏ
                      : (isMissing ? Colors.orange : Colors.black), // Thiếu: cam
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
            const SizedBox(height: 5),
            Text("Correct Answers: ${correctAnswers.join(', ')}", style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }



}
