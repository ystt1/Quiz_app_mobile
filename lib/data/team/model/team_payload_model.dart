class TeamPayloadModel{
  final String name;
  final String image;
  final int maxParticipant;
  final String code;

  TeamPayloadModel({required this.name, required this.image, required this.maxParticipant, required this.code});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'image': this.image,
      'maxParticipant': this.maxParticipant,
      'code': this.code,
    };
  }

  factory TeamPayloadModel.fromMap(Map<String, dynamic> map) {
    return TeamPayloadModel(
      name: map['name'] as String,
      image: map['image'] as String,
      maxParticipant: map['maxParticipant'] as int,
      code: map['code'] as String,
    );
  }
}