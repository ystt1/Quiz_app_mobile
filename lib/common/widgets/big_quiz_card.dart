import 'package:flutter/material.dart';

import '../../domain/quiz/entity/basic_quiz_entity.dart';
import '../../presentation/quiz/pages/practice_quiz_detail_page.dart';

class BigQuizCard extends StatelessWidget {
  final BasicQuizEntity quiz;
  const BigQuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PracticeQuizDetailPage(quiz: quiz,)),
      );},
      child: Row(
        children: [
          Container(
            height: 200,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image:  DecorationImage(
                image: NetworkImage(quiz.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
           const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${quiz.topicId.isEmpty?"not found":quiz.topicId[0].name }",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                   Text(
                    quiz.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                   Text(
                    quiz.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                   Text(
                    "Questions: ${quiz.questionNumber}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                   Text(
                    "Time: ${quiz.time} minutes",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
