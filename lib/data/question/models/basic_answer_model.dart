import 'package:quiz_app/domain/question/entity/basic_answer_entity.dart';

class BasicAnswerModel{
  final String content;
  final bool isCorrect;

  BasicAnswerModel({ required this.content, required this.isCorrect});

  Map<String, dynamic> toMap() {
    return {
      'content': this.content,
      'isCorrect': this.isCorrect,
    };
  }

  factory BasicAnswerModel.fromMap(Map<String, dynamic> map) {
    return BasicAnswerModel(
      content: map['content'] as String,
      isCorrect: (map['isCorrect'] as bool)??true,
    );
  }
}

extension BasicAnswerModelToEntity on BasicAnswerModel{
  BasicAnswerEntity toEntity()
  {
    return BasicAnswerEntity(content: content, isCorrect: isCorrect);
  }
}