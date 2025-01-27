import 'package:flutter/material.dart';
import 'package:quiz_app/core/constant/app_color.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

class QuizCard extends StatelessWidget {
  final VoidCallback onClick;
  final bool isYour;
  final BasicQuizEntity quiz;
  final bool isSelected;
  final bool isSelectedMode;

  const QuizCard(
      {super.key,
      required this.onClick,
      required this.isYour,
      required this.quiz, this.isSelected=false, this.isSelectedMode=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _image(),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 105,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _nameAndMenu(),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _information(Icons.timer, '${quiz.time} min'),
                        _information(Icons.help, '${quiz.questionNumber} question'),
                      ],
                    ),
                    SizedBox(height: 3,),
                    _information(Icons.date_range, quiz.createdAt),
                    SizedBox(height: 3,),
                    _tag(),
                    SizedBox(height: 1.5,),
                    const Divider(height: 0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return Container(
      width: 90,
      height: 105,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                quiz.image,
              ),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 0.3)),
    );
  }

  Widget _nameAndMenu() {
    return Row(
      children: [
        Expanded(
          child: Text(
            quiz.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        isSelectedMode
            ? Checkbox(
          value: isSelected,
          onChanged: (value) {

          },
        )
            : Icon(Icons.delete, color: Colors.red),
      ],
    );
  }

  Widget _tag() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: quiz.topicId
            .map(
              (topic) => Container(
                child: Row(
                  children: [
                    const Icon(Icons.tag, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      topic.name,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _information(IconData icon, String property) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          property,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
