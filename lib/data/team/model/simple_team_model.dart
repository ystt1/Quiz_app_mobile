import 'package:quiz_app/domain/team/entity/simple_team_entity.dart';

class SimpleTeamModel{
  final String id;
  final String image;
  final String name;

  SimpleTeamModel({required this.id, required this.image, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'image': this.image,
      'name': this.name,
    };
  }

  factory SimpleTeamModel.fromMap(Map<String, dynamic> map) {
    return SimpleTeamModel(
      id: map['_id'] as String,
      image: map['image'] ??"",
      name: map['name'] as String,
    );
  }
}

extension SimpleTeamModelToEntity on SimpleTeamModel{
  SimpleTeamEntity toEntity()
  {
    return SimpleTeamEntity(id: id, image: image, name: name);
  }
}