import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

class BasicQuizModel{
  final String id;
  final String name;
  final String description;
  final int numberQues;
  final int time;
  final List<String> topics;
  final String imgUrl;
  final String createdDate="29/01/2012";

  BasicQuizModel({required this.id, required this.name, required this.description, required this.numberQues, required this.time, required this.topics, required this.imgUrl});

}

extension BasicQuizModelToEntity on BasicQuizModel{
  BasicQuizEntity toEntity()
  {
    return BasicQuizEntity(id: id, name: name, description: description, numberQues: numberQues, time: time, topics: topics, imgUrl: imgUrl, createdDate: createdDate);
  }
}