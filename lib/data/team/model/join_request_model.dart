import 'package:quiz_app/data/team/model/simple_team_model.dart';
import 'package:quiz_app/data/user/model/simple_user_model.dart';
import 'package:quiz_app/domain/team/entity/join_request_entity.dart';

class JoinRequestModel {
  final String id;
  final SimpleTeamModel idTeam;
  final SimpleUserModel idUser;
  final String status;
  final String createdAt;
  final String updatedAt;

  JoinRequestModel(
      {required this.id,
      required this.idTeam,
      required this.idUser,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'idTeam': this.idTeam,
      'idUser': this.idUser,
      'status': this.status,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
    };
  }

  factory JoinRequestModel.fromMap(Map<String, dynamic> map) {
    return JoinRequestModel(
      id: map['_id'] as String,
      idTeam: SimpleTeamModel.fromMap(map['idTeam']),
      idUser: SimpleUserModel.fromMap(map['idUser']),
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }
}

extension JoinRequestModelToEntity on JoinRequestModel {
  JoinRequestEntity toEntity() {
    return JoinRequestEntity(
        id: id,
        idTeam: idTeam.toEntity(),
        idUser: idUser.toEntity(),
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }
}
