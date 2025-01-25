import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/data/quiz/models/topic_model.dart';
import 'package:quiz_app/data/quiz/service/quiz_service.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';

import '../../../service_locator.dart';

class QuizRepositoryImp extends QuizRepository {
  @override
  Future<Either> addQuestionToQuiz() async {
    return await sl<QuizService>().addQuestionToQuizService();
  }

  @override
  Future<Either> addQuiz() async {
    return await sl<QuizService>().addQuizService();
  }

  @override
  Future<Either> editQuizDetail() async {
    return await sl<QuizService>().editQuizDetailService();
  }

  @override
  Future<Either> getHotQuiz() async {
    try {
      final response = await sl<QuizService>().getHotQuizService();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<BasicQuizModel>)
            .map((BasicQuizModel quiz) => quiz.toEntity()).toList();

        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getListMyQuiz() async {
    try {
      final response = await sl<QuizService>().getListMyQuizService();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<BasicQuizModel>)
            .map((BasicQuizModel quiz) => quiz.toEntity()).toList();

        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getListQuizOfTeam() async {
    return await sl<QuizService>().getListQuizOfTeamService();
  }

  @override
  Future<Either> getNewestQuiz() async {
    try {
      final response = await sl<QuizService>().getNewestQuizService();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<BasicQuizModel>)
            .map((BasicQuizModel quiz) => quiz.toEntity()).toList();

        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getQuizDetail() async {
    return await sl<QuizService>().getQuizDetailService();
  }

  @override
  Future<Either> getRecentQuiz() async {
    try {
      final response = await sl<QuizService>().getRecentQuizService();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<BasicQuizModel>)
            .map((BasicQuizModel quiz) => quiz.toEntity()).toList();

        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> removeQuestionFromQuiz() async {
    return await sl<QuizService>().removeQuestionFromQuizService();
  }

  @override
  Future<Either> searchListQuiz() async {
    try {
      final response = await sl<QuizService>().getRecentQuizService();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<BasicQuizModel>)
            .map((BasicQuizModel quiz) => quiz.toEntity()).toList();
        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getAllTopic() async {
    try {
      final response = await sl<QuizService>().getAllTopic();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<TopicModel>)
            .map((TopicModel topic) => topic.toEntity()).toList();
        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }
}
