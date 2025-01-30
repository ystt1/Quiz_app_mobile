import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class FillInTheBlank extends StatelessWidget {
  final BasicQuestionEntity question;
  final Function(PracticePayloadModel result) onChange;
  final PracticePayloadModel result;
  final int index;
  const FillInTheBlank({
    super.key,
    required this.question,
    required this.onChange,
    required this.result, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    List<String> currentAnswers = result.userAnswers[index];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text.rich(
        TextSpan(
          children: question.content
              .split('___')
              .asMap()
              .entries
              .expand<InlineSpan>((entry) {
            final blankIndex = entry.key;
            final text = entry.value;

            return [
              TextSpan(
                text: text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ), // Text before blank
              if (blankIndex < question.answers.length)
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: TextEditingController(
                            text: currentAnswers.length > blankIndex
                                ? currentAnswers[blankIndex]
                                : '',
                          ),
                          onChanged: (value) {
                            var updatedUserAnswers =
                            result.userAnswers.map((list) => List<String>.from(list)).toList();

                            if (updatedUserAnswers[index].length > blankIndex) {
                              updatedUserAnswers[index][blankIndex] = value;
                            } else {
                              updatedUserAnswers[index].add(value);
                            }

                            var updatedResult = PracticePayloadModel(
                              userAnswers: updatedUserAnswers,
                              status: result.status,
                              completeTime: result.completeTime,
                                quizId: result.quizId
                            );

                            onChange(updatedResult);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Fill in the blank',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ];
          }).toList(),
        ),
      ),
    );
  }
}
