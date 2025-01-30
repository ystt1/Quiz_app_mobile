class ResultEntity {
  final String idParticipant;
  final String quizId;
  final List<List<String>> userAnswers;
  final int score;
  final int completeTime;
  final String status;
  final int attemptTime;
  final String id;
  final String createdAt;
  final String updatedAt;

  ResultEntity({
    required this.idParticipant,
    required this.quizId,
    required this.userAnswers,
    required this.score,
    required this.completeTime,
    required this.status,
    required this.attemptTime,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResultEntity.fromMap(Map<String, dynamic> map) {
    return ResultEntity(
      idParticipant: map['idParticipant'] ?? '',
      quizId: map['idQuiz'] ?? '',
      userAnswers: (map['userAnswers'] as List?)?.map((innerList) => (innerList as List?)?.map((e) => e?['content']?.toString() ?? '').toList() ?? []).toList() ?? [],
      score: map['score'] ?? 0,
      completeTime: map['completeTime'] ?? 0,
      status: map['status'] ?? 'unknown',
      attemptTime: map['attempTime'] ?? 0,
      id: map['_id'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now().toString(),
      updatedAt: map['updatedAt'] ?? DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idParticipant': idParticipant,
      'idQuiz': quizId,
      'userAnswers': userAnswers.map((list) => list.map((e) => {'content': e}).toList()).toList(),
      'score': score,
      'completeTime': completeTime,
      'status': status,
      'attempTime': attemptTime,
    };
  }
}
