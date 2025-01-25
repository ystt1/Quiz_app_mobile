import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';

import '../../../service_locator.dart';

class SearchListQuizUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<QuizRepository>().searchListQuiz();
  }

}