class SimpleQuizEntity{
  final String id;
  final String name;
  final String image;

  SimpleQuizEntity({required this.id, required this.name, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
    };
  }

  factory SimpleQuizEntity.fromMap(Map<String, dynamic> map) {
    return SimpleQuizEntity(
      id: map['_id'] ?? "",
      name: map['name'] ?? "",
      image: map['image'] ?? "",
    );
  }
}