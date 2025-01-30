import 'package:quiz_app/domain/team/entity/team_entity.dart';

class TeamModel {
  final String id;
  final String idHost;
  final String name;
  final String image;
  final int maxParticipant;
  final String code;
  final String createdAt;
  final String updatedAt;
  final String joinStatus;

  TeamModel(
      {required this.id,
      required this.idHost,
      required this.name,
      required this.image,
      required this.maxParticipant,
      required this.code,
      required this.createdAt,
      required this.updatedAt,
      required this.joinStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'idHost': this.idHost,
      'name': this.name,
      'image': this.image,
      'maxParticipant': this.maxParticipant,
      'code': this.code,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'joinStatus': this.joinStatus,
    };
  }

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['_id'] ?? '',
      idHost: map['idHost'] ?? '',
      name: map['name'] ?? 'notFound',
      image: map['image'] ?? '',
      maxParticipant: map['maxParticipant'] ?? 0,
      code: map['code'] ?? 'notFound',
      createdAt: map['createdAt'] ?? DateTime.now().toString(),
      updatedAt: map['updatedAt'] ?? DateTime.now().toString(),
      joinStatus: map['joinStatus'] ?? 'not-joined',
    );
  }
}

extension TeamModelToEntity on TeamModel {
  TeamEntity toEntity() {
    return TeamEntity(
        id: id,
        idHost: idHost,
        name: name,
        image: image,
        maxParticipant: maxParticipant,
        code: code,
        createdAt: createdAt,
        updatedAt: updatedAt,
        joinStatus: joinStatus);
  }
}
