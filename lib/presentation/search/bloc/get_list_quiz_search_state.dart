import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

abstract class GetListQuizSearchState{}

class GetListQuizSearchInitial extends GetListQuizSearchState{}

class GetListQuizSearchLoading extends GetListQuizSearchState{}

class GetListQuizSearchSuccess extends GetListQuizSearchState{
  final List<BasicQuizEntity> listQuiz;

  GetListQuizSearchSuccess({required this.listQuiz});
}

class GetListQuizSearchFailure extends GetListQuizSearchState{
  final String error;

  GetListQuizSearchFailure({required this.error});
}