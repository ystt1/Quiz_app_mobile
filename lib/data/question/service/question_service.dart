import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/constant/url.dart';
import 'package:quiz_app/data/api_service.dart';
import 'package:quiz_app/data/question/models/basic_answer_model.dart';
import 'package:quiz_app/data/question/models/basic_question_model.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/data/question/models/edit_question_payload_model.dart';
import 'package:quiz_app/data/question/models/question_payload_model.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/service_locator.dart';
abstract class QuestionService{
  Future<Either> addQuestionService(QuestionPayload question);
  Future<Either> deleteQuestionService(String id);
  Future<Either> editQuestionService(EditQuestionPayloadModel question);
  Future<Either> getListQuestionService(String quizId);
  Future<Either> getListMyQuestionService(SearchAndSortModel searchSort);
  Future<Either> getQuestionDetailService();
}

class QuestionServiceImp extends QuestionService {



  @override
  Future<Either> addQuestionService(QuestionPayload question) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.post('$url/question', question.toMap());
      if(response.statusCode==200)
      {
        return Right(true);
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteQuestionService(String id) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.delete('$url/question/$id',{});
      if(response.statusCode==200)
      {
        return Right(true);
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> editQuestionService(EditQuestionPayloadModel question) async {
    try {

      final apiService = sl<ApiService>();
      final response = await apiService.put('$url/question/${question.id}', question.toMap());
      if(response.statusCode==200)
      {
        return Right(true);
      };

      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }




  @override
  Future<Either> getListQuestionService(String quizId) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get('$url/quiz/practice/${quizId}');
      if(response.statusCode==200)
      {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final quizzes = data.map((quiz) => BasicQuestionModel.fromMap(quiz)).toList();
        return Right(quizzes);
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getQuestionDetailService() {
    // TODO: implement getQuestionDetailService
    throw UnimplementedError();
  }

  @override
  Future<Either> getListMyQuestionService(SearchAndSortModel searchSort) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get('$url/question/get-my-question?name=${searchSort.name}&sortField=${searchSort.sortField}&sortOrder=${searchSort.direction}');
      if(response.statusCode==200)
      {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final quizzes = data.map((quiz) => BasicQuestionModel.fromMap(quiz)).toList();
        return Right(quizzes);
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {

      return Left(e.toString());
    }
  }

}