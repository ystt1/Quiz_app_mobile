import 'package:flutter/material.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/presentation/quiz/pages/practice_quiz_detail_page.dart';

class SliderCard extends StatelessWidget {
  final BasicQuizEntity quiz;

  const SliderCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: (){Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PracticeQuizDetailPage(quizId: quiz.id,)),
        );},
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Base64ImageWidget(base64String: quiz.image,)),
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
      ),
    );
  }
}
