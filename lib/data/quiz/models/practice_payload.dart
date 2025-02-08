class PracticePayloadModel {
  final List<String> questions;
  final List<List<String>> userAnswers;
  final String status;
  final int completeTime;
  final String quizId;

  PracticePayloadModel({
    required this.questions,
    required this.userAnswers,
    required this.status,
    required this.completeTime,
    required this.quizId,
  });

  Map<String, dynamic> toMap() {
    return {
      'questions':questions,
      'idQuiz':quizId,
      'userAnswers': userAnswers.map((answerList) {
        return answerList.map((answer) {
          return {'content': answer};
        }).toList();
      }).toList(),
      'status': status,
      'completeTime': completeTime,
    };
  }

}
