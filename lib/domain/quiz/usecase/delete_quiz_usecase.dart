import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';

import '../../../service_locator.dart';

class DeleteQuizUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String? params}) async {
   return await sl<QuizRepository>().deleteQuiz(params!);
  }

}