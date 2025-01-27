import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/quiz/models/edit_quiz_model.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';

import '../../../service_locator.dart';

class EditQuizDetailUseCase implements UseCase<Either,EditQuizModel> {
  @override
  Future<Either> call({EditQuizModel? params}) async {
    return await sl<QuizRepository>().editQuizDetail(params!);
  }

}