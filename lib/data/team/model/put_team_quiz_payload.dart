class PutTeamQuizPayload{
  final String idTeam;
  final List<String> quizIds;

  PutTeamQuizPayload({required this.idTeam, required this.quizIds});

  Map<String, dynamic> toMap() {
    return {
      'addQuiz': this.quizIds,
    };
  }

}