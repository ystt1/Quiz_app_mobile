import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class SelectedOne extends StatelessWidget {
  final BasicQuestionEntity question;
  final Function(PracticePayloadModel result) onChange;
  final PracticePayloadModel result;
  final int index;
  const SelectedOne(
      {super.key,
      required this.question,
      required this.onChange,
      required this.result, required this.index});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.answers.map<Widget>((answer) {
        return Row(
          children: [
            Radio(
              value: answer.content,
              groupValue:result.userAnswers[index].isNotEmpty ? result.userAnswers[index].first : null,
              onChanged: (value) {
                var updatedUserAnswers = result.userAnswers.map((list) => List<String>.from(list)).toList();
                updatedUserAnswers[index] = [value as String];

                var updatedResult = PracticePayloadModel(
                  userAnswers: updatedUserAnswers,
                  status: result.status,
                  completeTime: result.completeTime,
                    quizId: result.quizId, questions: result.questions
                );

                onChange(updatedResult);
              },
            ),
            Expanded(child: Text(answer.content)),
          ],
        );
      }).toList(),
    );
  }
}
