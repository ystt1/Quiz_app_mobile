import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/domain/question/repository/question_repository.dart';

import '../../../service_locator.dart';

class GetMyQuestionUseCase implements UseCase<Either,SearchAndSortModel> {
  @override
  Future<Either> call({SearchAndSortModel? params}) async {
   return await sl<QuestionRepository>().getMyQuestion(params!);
  }

}