import 'package:flutter/material.dart';
import 'package:quiz_app/common/widgets/quiz_card.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/entity/quiz_entity.dart';

import '../pages/quiz_detail_page.dart';

class QuizList extends StatelessWidget {
  final List<BasicQuizEntity> quizList;
  final bool isYour;
  const QuizList({super.key, required this.quizList, required this.isYour});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: quizList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return QuizCard(onClick: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => QuizDetailPage(quiz: QuizEntity(quizName: "quiz test", quizDescription: "test description", quizImageUrl: "https://media.istockphoto.com/id/1616906708/vector/vector-speech-bubble-with-quiz-time-words-trendy-text-balloon-with-geometric-grapic-shape.jpg?s=612x612&w=0&k=20&c=3-qsji8Y5QSuShaMi6cqONlVZ3womknA5CiJ4PCeZEI=", topics: ["Math","Technology"], createdDate: "29/01/2020", isPrivate: true, questions: [], time: 12))),
          );
        }, isYour: isYour, quiz: quizList[index],
        );
      },
    );
  }
}
