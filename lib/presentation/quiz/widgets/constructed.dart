import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class Constructed extends StatelessWidget {
  final BasicQuestionEntity question;
  final Function(PracticePayloadModel result) onChange;
  final PracticePayloadModel result;
  final index;
  const Constructed({
    super.key,
    required this.question,
    required this.onChange,
    required this.result, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String currentAnswer = result.userAnswers[index].isNotEmpty ? result.userAnswers[index].first : '';

    return TextField(
      decoration: const InputDecoration(labelText: 'Your answer'),
      controller: TextEditingController(text: currentAnswer),
      onChanged: (value) {
        var updatedUserAnswers = result.userAnswers.map((list) => List<String>.from(list)).toList();
        updatedUserAnswers[index] = [value];

        var updatedResult = PracticePayloadModel(
          userAnswers: updatedUserAnswers,
          status: result.status,
          completeTime: result.completeTime,
          quizId: result.quizId
        );

        onChange(updatedResult);
      },
    );
  }
}
