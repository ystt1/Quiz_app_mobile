import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/constant/url.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/data/quiz/models/leader_board_model.dart';
import 'package:quiz_app/data/quiz/models/practice_payload.dart';
import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/data/quiz/models/quiz_payload_model.dart';
import 'package:quiz_app/data/quiz/models/quiz_quetion_payload.dart';
import 'package:quiz_app/data/quiz/models/result_model.dart';
import 'package:quiz_app/data/quiz/models/topic_model.dart';

import '../../../service_locator.dart';
import '../../api_service.dart';
import '../models/edit_quiz_model.dart';

abstract class QuizService {
  Future<Either> deleteQuizService(String id);

  Future<Either> addQuizService(QuizPayloadModel quiz);

  Future<Either> addQuestionToQuizService(QuizQuestionPayload quizQues);

  Future<Either> editQuizDetailService(EditQuizModel quiz);

  Future<Either> getHotQuizService(String filter);

  Future<Either> getListMyQuizService(SearchAndSortModel searchSort);

  Future<Either> getListQuizOfTeamService();

  Future<Either> getNewestQuizService();

  Future<Either> getQuizDetailService(String id);

  Future<Either> getRecentQuizService();

  Future<Either> removeQuestionFromQuizService(QuizQuestionPayload quizQues);

  Future<Either> searchListQuizService();

  Future<Either> getAllTopic();

  Future<Either> submitResultService(PracticePayloadModel result);

  Future<Either> getLeaderBoard(String idQuiz);

  Future<Either> getListResultService(String params);
}

class QuizServiceImp extends QuizService {
  @override
  Future<Either> getHotQuizService(String filter) async {
    try {
      print(filter);
      final uri = Uri.parse('http://$url:5000/api/quiz?status=active&$filter');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final quizzes =
            data.map((quiz) => BasicQuizModel.fromMap(quiz)).toList();
        return Right(quizzes);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getListMyQuizService(SearchAndSortModel searchSort) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get(
        'http://$url:5000/api/quiz/get-my-quiz?name=${searchSort.name}&sortField=${searchSort.sortField}&sortOrder=${searchSort.direction}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final quizzes =
            data.map((quiz) => BasicQuizModel.fromMap(quiz)).toList();
        return Right(quizzes);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getListQuizOfTeamService() {
    // TODO: implement getListQuizOfTeamService
    throw UnimplementedError();
  }

  @override
  Future<Either> getNewestQuizService() async {
    try {
      final uri = Uri.parse(
          'http://$url:5000/api/quiz?filterType=newest&status=active');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final quizzes =
            data.map((quiz) => BasicQuizModel.fromMap(quiz)).toList();
        return Right(quizzes);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getQuizDetailService(String id) async {
    try {
      final uri = Uri.parse('http://$url:5000/api/quiz/$id');
      final response = await http.get(uri);
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        BasicQuizModel quiz = BasicQuizModel.fromMap(data);
        return Right(quiz);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getRecentQuizService() async {
    try {
      final uri = Uri.parse(
          'http://$url:5000/api/quiz?filterType=recent&status=active');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final quizzes =
            data.map((quiz) => BasicQuizModel.fromMap(quiz)).toList();
        return Right(quizzes);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> removeQuestionFromQuizService(
      QuizQuestionPayload quizQues) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.delete(
          'http://$url:5000/api/quiz/${quizQues.quizId}/questions',
          quizQues.toMap());

      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> searchListQuizService() async {
    try {
      final uri = Uri.parse('http://$url:5000/api/quiz');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final quizzes =
            data.map((quiz) => BasicQuizModel.fromMap(quiz)).toList();
        return Right(quizzes);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getAllTopic() async {
    try {
      final uri = Uri.parse('http://$url:5000/api/topic');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final topics = data.map((topic) => TopicModel.fromMap(topic)).toList();
        return Right(topics);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addQuestionToQuizService(QuizQuestionPayload quizQues) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.post(
          'http://$url:5000/api/quiz/${quizQues.quizId}/questions',
          quizQues.toMap());

      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addQuizService(QuizPayloadModel quiz) async {
    try {
      final apiService = sl<ApiService>();
      final response =
          await apiService.post('http://$url:5000/api/quiz', quiz.toMap());

      if (response.statusCode == 200) {
        return Right(true);
      }
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> editQuizDetailService(EditQuizModel quiz) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.put(
          'http://$url:5000/api/quiz/${quiz.id}', quiz.toMap());

      if (response.statusCode == 200) {
        return Right(true);
      }
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> submitResultService(PracticePayloadModel result) async {
    try {
      final apiService = sl<ApiService>();
      final response =
          await apiService.post('http://$url:5000/api/result', result.toMap());
      print(response.body);
      if (response.statusCode == 200) {
        final data = ResultModel.fromMap(jsonDecode(response.body)["data"]);
        return Right(data);
      }
      return Left(
          (jsonDecode(response.body)["message"]) ?? "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getLeaderBoard(String idQuiz) async {
    try {
      print("idQUiz"+idQuiz);
      final apiService = sl<ApiService>();
      final response = await apiService
          .post('http://$url:5000/api/result/leadboard', {"idQuiz": idQuiz});
      print(jsonDecode(response.body)["data"]["myData"]);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse["data"] == null) {
          return Left("No leaderboard data found");
        }
        final leaderBoard = LeaderBoardModel.fromMap(decodedResponse["data"]);
        return Right(leaderBoard);
      }
      ;
      return Left((jsonDecode(response.body)["message"]) ??
          Left((jsonDecode(response.body)["message"][["message"]])));
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getListResultService(String params) async {
    try {
      print(params);
      final apiService = sl<ApiService>();
      final response = await apiService.get(
        'http://$url:5000/api/result?$params',
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final results =
            data.map((result) => ResultModel.fromMap(result)).toList();
        return Right(results);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          (jsonDecode(response.body)["message"]));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteQuizService(String id) async {
    try {
      final apiService = sl<ApiService>();
      final response =
          await apiService.delete('http://$url:5000/api/quiz/$id', {});
      if (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
