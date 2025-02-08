import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/team/entity/team_member_entity.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class TeamEntity {
  final String id;
  final SimpleUserEntity idHost;
  final String name;
  final String image;
  final int maxParticipant;
  final String code;
  final String createdAt;
  final String updatedAt;
  late String joinStatus;
  late List<TeamMemberEntity> members;
  final int memberCount;
  final int quizCount;
  final List<BasicQuizEntity> quizzes;
  TeamEntity({
    required this.id,
    required this.idHost,
    required this.name,
    required this.image,
    required this.maxParticipant,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
    required this.joinStatus,
    required this.members,
    required this.memberCount,
    required this.quizCount,
    required this.quizzes,
  });


}
