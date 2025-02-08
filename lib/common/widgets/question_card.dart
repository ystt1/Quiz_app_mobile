import 'package:flutter/material.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';

class QuestionCard extends StatelessWidget {
  final int index;
  final VoidCallback onDelete;
  final BasicQuestionEntity question;
  final bool isSelected;
  final bool isSelectedMode;
  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.onDelete,
    this.isSelected = false,
    this.isSelectedMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.shade100 : Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                !isSelectedMode?
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.red),
                      );
                    }
                  ):Checkbox(value: isSelected, onChanged: (value){})
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem(Icons.calendar_today, 'Created', question.dateCreated),
                _infoItem(Icons.quiz, 'Type', question.type),
                _infoItem(Icons.score, 'Score', question.score.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}


