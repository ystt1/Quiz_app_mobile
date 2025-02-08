import 'package:quiz_app/domain/quiz/entity/simple_quiz_entity.dart';

class SimpleQuizModel{
  final String id;
  final String name;
  final String image;

  SimpleQuizModel({required this.id, required this.name, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
    };
  }

  factory SimpleQuizModel.fromMap(Map<String, dynamic> map) {
    return SimpleQuizModel(
      id: map['_id'] ?? "",
      name: map['name'] ?? "",
      image: map['image'] ?? "",
    );
  }
}

extension SimpleQuizModelToEntity on SimpleQuizModel {
  SimpleQuizEntity toEntity()
  {
    return SimpleQuizEntity(id: id, name: name, image: image);
  }
}