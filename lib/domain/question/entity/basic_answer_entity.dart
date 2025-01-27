import 'package:quiz_app/data/question/models/basic_answer_model.dart';

class BasicAnswerEntity{

  final String content;
  final bool isCorrect;

  BasicAnswerEntity({required this.content, required this.isCorrect});
}

extension BasicAnswerEntityToModel on BasicAnswerEntity{
  BasicAnswerModel toModel()
  {
    return BasicAnswerModel(content: content, isCorrect: isCorrect);
  }
}