import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/quiz/models/quiz_quetion_payload.dart';

import '../../../service_locator.dart';
import '../repository/quiz_repository.dart';

class AddQuestionToQuizUseCase implements UseCase<Either,QuizQuestionPayload> {
  @override
  Future<Either> call({QuizQuestionPayload? params}) async {
    return await sl<QuizRepository>().addQuestionToQuiz(params!);
  }

}