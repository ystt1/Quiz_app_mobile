class PracticePayloadModel {

  final List<List<String>> userAnswers;
  final String status;
  final int completeTime;
  final String quizId;

  PracticePayloadModel({

    required this.userAnswers,
    required this.status,
    required this.completeTime,
    required this.quizId,
  });

  Map<String, dynamic> toMap() {
    return {
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
