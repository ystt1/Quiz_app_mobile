import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';

import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';
import 'package:quiz_app/service_locator.dart';

class SubmitResultUseCase implements UseCase<Either,PracticePayloadModel> {
  @override
  Future<Either> call({PracticePayloadModel? params}) async {
    return await sl<QuizRepository>().submitResult(params!);
  }

}