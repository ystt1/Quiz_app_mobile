import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/quiz/models/quiz_payload_model.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';
import 'package:quiz_app/service_locator.dart';

class AddQuizUseCase implements UseCase<Either,QuizPayloadModel> {
  @override
  Future<Either> call({QuizPayloadModel? params}) async {
    return await sl<QuizRepository>().addQuiz(params!);
  }

}