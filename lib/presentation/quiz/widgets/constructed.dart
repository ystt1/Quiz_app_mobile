import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class Constructed extends StatefulWidget {
  final BasicQuestionEntity question;
  final Function(PracticePayloadModel result) onChange;
  final PracticePayloadModel result;
  final int index;

  const Constructed({
    super.key,
    required this.question,
    required this.onChange,
    required this.result,
    required this.index,
  });

  @override
  _ConstructedState createState() => _ConstructedState();
}

class _ConstructedState extends State<Constructed> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.result.userAnswers[widget.index].isNotEmpty
            ? widget.result.userAnswers[widget.index].first
            : '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    var updatedUserAnswers =
    widget.result.userAnswers.map((list) => List<String>.from(list)).toList();
    updatedUserAnswers[widget.index] = [value];

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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Your Answer',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: _onTextChanged,
      ),
    );
  }
}
