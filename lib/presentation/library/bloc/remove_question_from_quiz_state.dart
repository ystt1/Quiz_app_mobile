abstract class RemoveQuestionFromQuizState{}

class RemoveQuestionFromQuizLoading extends RemoveQuestionFromQuizState{}

class RemoveQuestionFromQuizSuccess extends RemoveQuestionFromQuizState{
}

class RemoveQuestionFromQuizFailure extends RemoveQuestionFromQuizState{
  final String error;

  RemoveQuestionFromQuizFailure({required this.error});
}