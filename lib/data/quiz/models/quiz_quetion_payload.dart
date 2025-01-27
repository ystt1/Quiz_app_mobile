

class QuizQuestionPayload{
  final String quizId;
  final List<String> question;

  QuizQuestionPayload({required this.quizId, required this.question});

  Map<String, dynamic> toMap() {
    return {
      'questions': question,
    };
  }

}