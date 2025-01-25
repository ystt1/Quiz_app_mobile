import 'package:flutter/material.dart';
import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

class SliderCard extends StatelessWidget {
  final BasicQuizEntity quiz;

  const SliderCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(quiz.imgUrl), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black)),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                quiz.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
