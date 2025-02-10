import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

abstract class GetListQuizState3{}
class GetListQuizInitialState3 extends GetListQuizState3{}
class GetListQuizLoading3 extends GetListQuizState3{}

class GetListQuizSuccess3 extends GetListQuizState3{
  final List<BasicQuizEntity> quizzes;
  GetListQuizSuccess3({required this.quizzes});
}
class GetListQuizFailure3 extends GetListQuizState3{
  final String error;
  GetListQuizFailure3({required this.error});
}


