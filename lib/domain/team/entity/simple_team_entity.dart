class SimpleTeamEntity{
  final String id;
  final String image;
  final String name;

  SimpleTeamEntity({required this.id, required this.image, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'image': this.image,
      'name': this.name,
    };
  }

  factory SimpleTeamEntity.fromMap(Map<String, dynamic> map) {
    return SimpleTeamEntity(
      id: map['_id'] as String,
      image: map['image'] as String,
      name: map['name'] as String,
    );
  }
}