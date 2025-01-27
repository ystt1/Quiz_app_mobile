import 'package:quiz_app/data/question/models/basic_answer_model.dart';

class QuestionPayload{
  final String content;
  final int score;
  final String type;
  final List<BasicAnswerModel> answers;

  QuestionPayload({required this.content, required this.score, required this.type, required this.answers});

  Map<String, dynamic> toMap() {
    return {
      'content': this.content,
      'score': this.score,
      'type': this.type,
      'answers': this.answers.map((e)=>e.toMap()).toList(),
    };
  }

  factory QuestionPayload.fromMap(Map<String, dynamic> map) {
    return QuestionPayload(
      content: map['content'] as String,
      score: map['score'] as int,
      type: map['type'] as String,
      answers: map['answers'] as List<BasicAnswerModel>,
    );
  }
}