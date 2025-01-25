import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/question/models/basic_question_model.dart';
import 'package:quiz_app/data/question/service/question_service.dart';
import 'package:quiz_app/domain/question/repository/question_repository.dart';

import '../../../service_locator.dart';

class QuestionRepositoryImp extends QuestionRepository {
  @override
  Future<Either> addQuestion() async {
    return await sl<QuestionService>().addQuestionService();
  }

  @override
  Future<Either> deleteQuestion() async {
    return await sl<QuestionService>().deleteQuestionService();
  }

  @override
  Future<Either> editQuestion() async {
    return await sl<QuestionService>().editQuestionService();
  }

  @override
  Future<Either> getListQuestion() async {
    try {
      final response = await sl<QuestionService>().getListQuestionService();
      return response.fold((error) => Left(error), (data) {
        var returnData = (data as List<BasicQuestionModel>)
            .map((e) => e.toEntity())
            .toList();
        return Right(returnData);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getQuestionDetail() async {
    return await sl<QuestionService>().getQuestionDetailService();
  }
}
