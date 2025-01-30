import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/question/repository/question_repository.dart';

import '../../../service_locator.dart';

class GetListQuestionUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async {
   return await sl<QuestionRepository>().getListQuestion(params);
  }

}