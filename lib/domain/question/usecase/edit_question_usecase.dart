import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/question/models/edit_question_payload_model.dart';
import 'package:quiz_app/domain/question/repository/question_repository.dart';
import 'package:quiz_app/service_locator.dart';

class EditQuestionUseCase implements UseCase<Either,EditQuestionPayloadModel> {
  @override
  Future<Either> call({EditQuestionPayloadModel? params}) async {
    return await sl<QuestionRepository>().editQuestion(params!);
  }

}