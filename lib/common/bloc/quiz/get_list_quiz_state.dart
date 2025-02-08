import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

abstract class GetListQuizState{}
class GetListQuizInitialState extends GetListQuizState{}
class GetListQuizLoading extends GetListQuizState{}

class GetListQuizSuccess extends GetListQuizState{
  final List<BasicQuizEntity> quizzes;
  GetListQuizSuccess({required this.quizzes});
}
class GetListQuizFailure extends GetListQuizState{
  final String error;
  GetListQuizFailure({required this.error});
}


