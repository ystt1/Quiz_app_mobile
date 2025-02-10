import 'package:flutter/material.dart';
import 'package:quiz_app/core/constant/app_color.dart';
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

    /// Đảm bảo danh sách userAnswers có đủ số lượng phần tử
    while (widget.result.userAnswers.length <= widget.index) {
      widget.result.userAnswers.add([]);
    }
    while (widget.result.userAnswers[widget.index].length < widget.question.answers.length) {
      widget.result.userAnswers[widget.index].add('');
    }

    /// Khởi tạo danh sách TextEditingController
    controllers = List.generate(
      widget.question.answers.length,
          (i) => TextEditingController(
        text: widget.result.userAnswers[widget.index][i],
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

    updatedUserAnswers[widget.index][blankIndex] = value;

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
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 18, color: AppColors.textColor),
          children: widget.question.content
              .split('___')
              .asMap()
              .entries
              .expand<InlineSpan>((entry) {
            final blankIndex = entry.key;
            final text = entry.value;

            return [
              TextSpan(text: text),
              if (blankIndex < widget.question.answers.length)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: controllers[blankIndex],
                        onChanged: (value) => _updateAnswer(blankIndex, value),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: '...',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(fontSize: 16, color: Colors.black),
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
