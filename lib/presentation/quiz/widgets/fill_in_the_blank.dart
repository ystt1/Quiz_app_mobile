import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class FillInTheBlank extends StatefulWidget {
  final BasicQuestionEntity question;
  final Function(PracticePayloadModel result) onChange;
  final PracticePayloadModel result;
  final int index;

  const FillInTheBlank({
    super.key,
    required this.question,
    required this.onChange,
    required this.result,
    required this.index,
  });

  @override
  _FillInTheBlankState createState() => _FillInTheBlankState();
}

class _FillInTheBlankState extends State<FillInTheBlank> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.question.answers.length,
          (i) => TextEditingController(
        text: widget.result.userAnswers[widget.index].length > i
            ? widget.result.userAnswers[widget.index][i]
            : '',
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateAnswer(int blankIndex, String value) {
    var updatedUserAnswers = widget.result.userAnswers
        .map((list) => List<String>.from(list))
        .toList();

    if (updatedUserAnswers[widget.index].length > blankIndex) {
      updatedUserAnswers[widget.index][blankIndex] = value;
    } else {
      updatedUserAnswers[widget.index].add(value);
    }

    var updatedResult = PracticePayloadModel(
      userAnswers: updatedUserAnswers,
      status: widget.result.status,
      completeTime: widget.result.completeTime,
      quizId: widget.result.quizId,
      questions: widget.result.questions,
    );

    widget.onChange(updatedResult);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text.rich(
        TextSpan(
          children: widget.question.content
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
              ),
              if (blankIndex < widget.question.answers.length)
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
                          controller: controllers[blankIndex],
                          onChanged: (value) => _updateAnswer(blankIndex, value),
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
