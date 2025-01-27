import 'basic_answer_model.dart';

class EditQuestionPayloadModel {
  final String content;
  final int score;
  final String type;
  final List<BasicAnswerModel> answers;
  final String id;

  EditQuestionPayloadModel(
      {required this.content,
      required this.score,
      required this.type,
      required this.answers,
      required this.id});

  Map<String, dynamic> toMap() {
    return {
      'content': this.content,
      'score': this.score,
      'type': this.type,
      'answers': this.answers.map((e) => e.toMap()).toList(),

    };
  }

  factory EditQuestionPayloadModel.fromMap(Map<String, dynamic> map) {
    return EditQuestionPayloadModel(
      content: map['content'] as String,
      score: map['score'] as int,
      type: map['type'] as String,
      answers: map['answers'] as List<BasicAnswerModel>,
      id: map['id'] as String,
    );
  }
}
