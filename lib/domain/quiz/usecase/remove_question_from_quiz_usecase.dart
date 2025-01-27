import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/quiz/models/quiz_quetion_payload.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';
import 'package:quiz_app/service_locator.dart';

class RemoveQuestionFromQuizUseCase implements UseCase<Either,QuizQuestionPayload> {
  @override
  Future<Either> call({QuizQuestionPayload? params}) async {
    return await sl<QuizRepository>().removeQuestionFromQuiz(params!);
  }

}