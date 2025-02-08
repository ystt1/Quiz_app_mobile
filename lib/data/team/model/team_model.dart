import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/data/team/model/team_member_model.dart';
import 'package:quiz_app/data/user/model/simple_user_model.dart';

import '../../../domain/team/entity/team_entity.dart';

class TeamModel {
  final String id;
  final SimpleUserModel idHost;
  final String name;
  final String image;
  final int maxParticipant;
  final String code;
  final String createdAt;
  final String updatedAt;
  final String joinStatus;
  final List<TeamMemberModel> members;
  final int memberCount;
  final int quizCount;
  final List<BasicQuizModel> quizzes;
  TeamModel( {
required this.quizzes,
    required this.id,
    required this.idHost,
    required this.name,
    required this.image,
    required this.maxParticipant,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
    required this.joinStatus,
    this.members = const [],
    this.memberCount = 0,
    this.quizCount = 0,
  });

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      quizzes: (map['quizzes'] as List<dynamic>?)?.map((e)=>BasicQuizModel.fromMap(e)).toList() ?? [],
      id: map['_id'] ?? '',
      idHost: SimpleUserModel.fromMap(map['idHost'] ?? {}),
      name: map['name'] ?? 'notFound',
      image: map['image'] ?? '',
      maxParticipant: map['maxParticipant'] ?? 0,
      code: map['code'] ?? '  notFound',
      createdAt: map['createdAt'] ?? DateTime.now().toString(),
      updatedAt: map['updatedAt'] ?? DateTime.now().toString(),
      joinStatus: map['joinStatus'] ?? 'not-joined',
      members: (map['members'] as List<dynamic>?)?.map((e) => TeamMemberModel.fromMap(e)).toList() ?? [],
      memberCount: map['memberCount']??0,
      quizCount: map['quizCount']??0,
    );
  }

  TeamEntity toEntity() {
    return TeamEntity(
      id: id,
      idHost: idHost.toEntity(),
      name: name,
      image: image,
      maxParticipant: maxParticipant,
      code: code,
      createdAt: createdAt,
      updatedAt: updatedAt,
      joinStatus: joinStatus,
      members: members.map((m) => m.toEntity()).toList(),
      memberCount: memberCount,
      quizCount: quizCount, quizzes: quizzes.map((m) => m.toEntity()).toList(),
    );
  }
}
