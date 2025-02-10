import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class SelectedMany extends StatelessWidget {
  final BasicQuestionEntity question;
  final Function(PracticePayloadModel result) onChange;
  final PracticePayloadModel result;
  final int index;
  const SelectedMany({
    super.key,
    required this.question,
    required this.onChange,
    required this.result, required this.index,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.answers.map<Widget>((answer) {
        bool isSelected = result.userAnswers[index].contains(answer.content);

        return Row(
          children: [
            Checkbox(
              value: isSelected,
                onChanged: (bool? selected) {
                  var updatedUserAnswers = result.userAnswers.map((list) => List<String>.from(list)).toList();

                  if (selected == true) {
                    if (!updatedUserAnswers[index].contains(answer.content)) {
                      updatedUserAnswers[index].add(answer.content);
                    }
                  } else {
                    updatedUserAnswers[index].remove(answer.content);
                  }

                  updatedUserAnswers[index] = updatedUserAnswers[index].where((ans) => ans.isNotEmpty).toList();
                  if (updatedUserAnswers[index].isEmpty) {
                    updatedUserAnswers[index] = [""];
                  }
                  var updatedResult = PracticePayloadModel(
                    userAnswers: updatedUserAnswers,
                    status: result.status,
                    completeTime: result.completeTime,
                    quizId: result.quizId,
                    questions: result.questions,
                  );

                  onChange(updatedResult);
                }


            ),
            Expanded(child: Text(answer.content)),
          ],
        );
      }).toList(),
    );
  }
}
