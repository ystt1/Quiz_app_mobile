class QuestionEntity{
  final String question;
  final String topic;
  final String difficulty;
  final String type;
  final String dateCreated;
  final List<String> correctAns;
  final List<String> wrongAns;

  QuestionEntity({required this.question, required this.topic, required this.difficulty, required this.type, required this.dateCreated, required this.correctAns, required this.wrongAns});

}