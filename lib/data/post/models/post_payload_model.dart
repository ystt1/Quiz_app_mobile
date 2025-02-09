class PostPayloadModel {
  final String content;
  final String team;
  final String? image;
  final String? quiz;

  PostPayloadModel(
      {required this.content, required this.team, required this.image,required this.quiz});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'content': content,
      'team': team,
      'image': image,
      'quiz': quiz,
    };


    data.removeWhere((key, value) => value == null || value == '');

    return data;
  }
}
