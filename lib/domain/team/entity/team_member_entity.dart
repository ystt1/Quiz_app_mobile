
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class TeamMemberEntity {
  final SimpleUserEntity member;
  final String role;

  TeamMemberEntity({required this.member, required this.role});


}