import 'package:quiz_app/domain/question/entity/basic_answer_entity.dart';

class BasicAnswerModel{
  final String id;
  final String content;
  final bool isCorrect;

  BasicAnswerModel({required this.id, required this.content, required this.isCorrect});
}

extension BasicAnswerModelToEntity on BasicAnswerModel{
  BasicAnswerEntity toEntity()
  {
    return BasicAnswerEntity(id: id, content: content, isCorrect: isCorrect);
  }
}