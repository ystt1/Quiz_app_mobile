class BasicQuizEntity{
  final String id;
  final String name;
  final String description;
  final int numberQues;
  final int time;
  final List<String> topics;
  final String imgUrl;
  final String createdDate;

  BasicQuizEntity({required this.id, required this.name, required this.description, required this.numberQues, required this.time, required this.topics, required this.imgUrl, required this.createdDate});

}