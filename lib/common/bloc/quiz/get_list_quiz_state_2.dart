import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

abstract class GetListQuizState2{}
class GetListQuizInitialState2 extends GetListQuizState2{}
class GetListQuizLoading2 extends GetListQuizState2{}

class GetListQuizSuccess2 extends GetListQuizState2{
  final List<BasicQuizEntity> quizzes;
  GetListQuizSuccess2({required this.quizzes});
}
class GetListQuizFailure2 extends GetListQuizState2{
  final String error;
  GetListQuizFailure2({required this.error});
}


