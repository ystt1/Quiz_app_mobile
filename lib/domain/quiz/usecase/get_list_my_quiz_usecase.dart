import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';
import 'package:quiz_app/service_locator.dart';

import '../../../data/question/models/search_sort_model.dart';

class GetListMyQuizUseCase implements UseCase<Either, SearchAndSortModel> {
  @override
  Future<Either> call({SearchAndSortModel? params}) async {
    return await sl<QuizRepository>().getListMyQuiz(params!);
  }
}
