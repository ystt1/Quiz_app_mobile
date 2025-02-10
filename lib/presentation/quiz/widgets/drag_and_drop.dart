import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class DragAndDrop extends StatefulWidget {
  final BasicQuestionEntity question;
  final Function(PracticePayloadModel result) onChange;
  final PracticePayloadModel result;
  final int index;

  const DragAndDrop({
    super.key,
    required this.question,
    required this.onChange,
    required this.result,
    required this.index,
  });

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  late List<String?> droppedAnswers;
  late List<bool> isDragged;

  @override
  void initState() {
    super.initState();
    int blanksCount = widget.question.content.split('___').length - 1;
    droppedAnswers = List.generate(blanksCount, (index) => null);
    isDragged = List.generate(widget.question.answers.length, (index) => false);
  }

  void updateAnswer(String? answer, int dropIndex) {
    setState(() {
      int? draggedFromIndex = droppedAnswers.indexOf(answer);
      String? swappedAnswer = droppedAnswers[dropIndex];

      if (draggedFromIndex != -1) droppedAnswers[draggedFromIndex] = swappedAnswer;
      droppedAnswers[dropIndex] = answer;

      for (int i = 0; i < isDragged.length; i++) {
        isDragged[i] = droppedAnswers.contains(widget.question.answers[i].content);
      }

      var updatedUserAnswers = widget.result.userAnswers
          .map((list) => List<String>.from(list))
          .toList();

      updatedUserAnswers[widget.index] = droppedAnswers
          .map((answer) => answer ?? "_")
          .toList();

      var updatedResult = PracticePayloadModel(
        userAnswers: updatedUserAnswers,
        status: widget.result.status,
        completeTime: widget.result.completeTime,
        quizId: widget.result.quizId,
        questions: widget.result.questions,
      );

      widget.onChange(updatedResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.question.answers.asMap().entries.map((entry) {
            int index = entry.key;
            String answer = entry.value.content;

            return Draggable<String>(
              data: answer,
              feedback: Material(
                color: Colors.transparent,
                child: Chip(
                  label: Text(answer),
                  backgroundColor: Colors.blue.withOpacity(0.8),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: Chip(label: Text(answer)),
              ),
              child: isDragged[index]
                  ? Opacity(opacity: 0.3, child: Chip(label: Text(answer)))
                  : Chip(label: Text(answer)),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.question.content
              .split('___')
              .asMap()
              .entries
              .expand<Widget>((entry) {
            final index = entry.key;
            final text = entry.value;

            return [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(text, style: const TextStyle(fontSize: 16)),
              ),
              if (index < droppedAnswers.length)
                DragTarget<String>(
                  onWillAccept: (_) => true,
                  onAccept: (data) => updateAnswer(data, index),
                  builder: (context, candidateData, rejectedData) {
                    bool isHovered = candidateData.isNotEmpty;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isHovered ? Colors.blue[100] : Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: droppedAnswers[index] == null
                          ? const Text(
                        'Drop here',
                        style: TextStyle(color: Colors.grey),
                      )
                          : Draggable<String>(
                        data: droppedAnswers[index],
                        feedback: Material(
                          color: Colors.transparent,
                          child: Chip(
                            label: Text(droppedAnswers[index]!),
                            backgroundColor: Colors.blue.withOpacity(0.8),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                        childWhenDragging: const SizedBox.shrink(),
                        onDragCompleted: () => updateAnswer(null, index),
                        child: Chip(label: Text(droppedAnswers[index]!)),
                      ),
                    );
                  },
                ),
            ];
          }).toList(),
        ),
      ],
    );
  }
}
