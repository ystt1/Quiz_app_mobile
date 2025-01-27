import 'package:flutter/material.dart';
import 'package:quiz_app/common/widgets/quiz_card.dart';
import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/entity/quiz_entity.dart';

import '../pages/quiz_detail_page.dart';

class QuizList extends StatefulWidget {
  final List<BasicQuizEntity> quizList;
  final bool isYour;
  final VoidCallback? onRefresh;
  const QuizList({super.key, required this.quizList, required this.isYour,this.onRefresh});

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  @override
  Widget build(BuildContext context) {
    List<BasicQuizEntity> _selectedQuiz = [];
    bool _isSelectedMode = false;

    return ListView.separated(
      itemCount: widget.quizList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            if (widget.isYour) {
              setState(() {
                _isSelectedMode = true;
                _selectedQuiz.add(widget.quizList[index]);
              });
            }
            print(_isSelectedMode);

            print(_selectedQuiz);
          },
          onTap: () {
            print(_isSelectedMode);

            print(_selectedQuiz);
            if (_isSelectedMode) {
              if (_selectedQuiz.contains(widget.quizList[index])) {
                setState(() {
                  _selectedQuiz.remove(widget.quizList[index]);
                });
              } else {
                setState(() {
                  _selectedQuiz.add(widget.quizList[index]);
                });
              }
              if(_selectedQuiz.isEmpty)
                {
                  setState(() {
                    _isSelectedMode=false;
                  });
                }
            }
          },
          child: QuizCard(
            onClick: () {

              if(!_isSelectedMode) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      QuizDetailPage(quiz: widget.quizList[index], onRefresh: widget.onRefresh!),
                ));
              }
            },
            isYour: widget.isYour,
            quiz: widget.quizList[index],
            isSelected: _selectedQuiz.contains(widget.quizList[index]),
            isSelectedMode: _isSelectedMode,
          ),
        );
      },
    );
  }
}
