import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/data/quiz/models/quiz_payload_model.dart';
import 'package:quiz_app/data/quiz/models/quiz_quetion_payload.dart';
import 'package:quiz_app/data/quiz/models/topic_model.dart';
import 'package:quiz_app/data/quiz/service/quiz_service.dart';
import 'package:quiz_app/domain/quiz/repository/quiz_repository.dart';

import '../../../service_locator.dart';
import '../models/edit_quiz_model.dart';

class QuizRepositoryImp extends QuizRepository {
  @override
  Future<Either> addQuestionToQuiz(QuizQuestionPayload quizQues) async {
    return await sl<QuizService>().addQuestionToQuizService(quizQues);
  }

  @override
  Future<Either> addQuiz(QuizPayloadModel quiz) async {
    return await sl<QuizService>().addQuizService(quiz);
  }

  @override
  Future<Either> editQuizDetail(EditQuizModel quiz) async {
    return await sl<QuizService>().editQuizDetailService(quiz);
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
  Future<Either> getListMyQuiz(SearchAndSortModel searchSort) async {
    try {
      final response = await sl<QuizService>().getListMyQuizService(searchSort);
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
  Future<Either> getQuizDetail(String id) async {
    try {
      final response = await sl<QuizService>().getQuizDetailService(id);
      return response.fold((error) => Left(error), (data) {
        final entity = (data as BasicQuizModel).toEntity();
        return Right(entity);
      });
    } catch (e) {
    return Left(e.toString());
    }
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
  Future<Either> removeQuestionFromQuiz(QuizQuestionPayload quizQues) async {
    return await sl<QuizService>().removeQuestionFromQuizService(quizQues);
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
