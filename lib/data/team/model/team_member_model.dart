import 'package:quiz_app/data/user/model/simple_user_model.dart';
import 'package:quiz_app/domain/team/entity/team_member_entity.dart';

class TeamMemberModel {
  final SimpleUserModel member;
  final String role;

  TeamMemberModel({required this.member, required this.role});

  factory TeamMemberModel.fromMap(Map<String, dynamic> map) {
    return TeamMemberModel(
      member: SimpleUserModel.fromMap(map['member'] ?? {}),
      role: map['role'] ?? 'participant',
    );
  }
}

extension TeamMemberModelToEntity on TeamMemberModel{
  TeamMemberEntity toEntity()
  {
    return TeamMemberEntity(member: member.toEntity(), role: role);
  }
}