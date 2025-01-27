import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/question/models/question_payload_model.dart';
import 'package:quiz_app/domain/question/repository/question_repository.dart';

import '../../../service_locator.dart';

class AddQuestionUseCase implements UseCase<Either,QuestionPayload> {
  @override
  Future<Either> call({QuestionPayload? params}) async {
   return await sl<QuestionRepository>().addQuestion(params!);
  }

}