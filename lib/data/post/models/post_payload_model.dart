class PostPayloadModel{
  final String content;
  final String team;
  final String? image;
  PostPayloadModel({required this.content,required this.team,required this.image});

  Map<String, dynamic> toMap() {
    if(image!=null && image!='')
      {
        return {
          'content': this.content,
          'team': this.team,
          'image':this.image,
        };
      }
    return {
      'content': this.content,
      'team': this.team,
    };
  }

  factory PostPayloadModel.fromMap(Map<String, dynamic> map) {
    return PostPayloadModel(
      content: map['content'] as String,
      team: map['team'] as String, image: '',
    );
  }
}