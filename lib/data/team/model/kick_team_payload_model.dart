class KickTeamPayLoadModel{
  final String teamId;
  final String kickUser;

  KickTeamPayLoadModel({required this.teamId, required this.kickUser});

  Map<String, dynamic> toMap() {
    return {
      'kickUser': this.kickUser,
    };
  }

  factory KickTeamPayLoadModel.fromMap(Map<String, dynamic> map) {
    return KickTeamPayLoadModel(
      teamId: map['teamId'] as String,
      kickUser: map['kickUser'] as String,
    );
  }
}