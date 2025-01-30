import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/question/repository/question_repository.dart';

import '../../../service_locator.dart';

class GetListPracticeUsecase implements UseCase<Either,String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<QuestionRepository>().getListQuestion(params!);
  }

}