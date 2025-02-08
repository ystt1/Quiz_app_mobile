import 'package:quiz_app/data/user/model/simple_user_model.dart';
import 'package:quiz_app/domain/team/entity/simple_team_entity.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class JoinRequestEntity {
  final String id;
  final SimpleTeamEntity idTeam;
  final SimpleUserEntity idUser;
  final String status;
  final String createdAt;
  final String updatedAt;

  JoinRequestEntity(
      {required this.id,
        required this.idTeam,
        required this.idUser,
        required this.status,
        required this.createdAt,
        required this.updatedAt});


}
