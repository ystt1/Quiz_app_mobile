import 'dart:convert';

import 'package:dartz/dartz.dart';
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
  Future<Either> deleteQuestionService();
  Future<Either> editQuestionService(EditQuestionPayloadModel question);
  Future<Either> getListQuestionService(String quizId);
  Future<Either> getListMyQuestionService(SearchAndSortModel searchSort);
  Future<Either> getQuestionDetailService();
}

class QuestionServiceImp extends QuestionService {

  final mockQuestions = [
    BasicQuestionModel(
      id: 'q1',
      content: 'What is the capital of France?',
      score: 10,
      type: 'multiple_choice',
      answers: [
        BasicAnswerModel( content: 'Paris', isCorrect: true),
        BasicAnswerModel(content: 'Berlin', isCorrect: false),
        BasicAnswerModel( content: 'Madrid', isCorrect: false),
        BasicAnswerModel(content: 'Rome', isCorrect: false),
      ], dateCreated: '29/01/2024',
    ),
    BasicQuestionModel(
      id: 'q2',
      content: 'Which programming language is used for Flutter development?',
      score: 15,
      type: 'single_choice',
      dateCreated: '29/01/2024',
      answers: [
        BasicAnswerModel( content: 'Java', isCorrect: false),
        BasicAnswerModel( content: 'Python', isCorrect: false),
        BasicAnswerModel( content: 'Dart', isCorrect: true),
        BasicAnswerModel( content: 'C++', isCorrect: false),
      ],
    ),
    BasicQuestionModel(
      id: 'q3',
      content: 'Select all prime numbers below:',
      score: 20,
      type: 'multiple_selection',
      dateCreated: '29/01/2024',
      answers: [
        BasicAnswerModel( content: '2', isCorrect: true),
        BasicAnswerModel(content: '4', isCorrect: false),
        BasicAnswerModel( content: '5', isCorrect: true),
        BasicAnswerModel( content: '8', isCorrect: false),
      ],
    ),
    BasicQuestionModel(
      id: 'q4',
      content: 'Fill in the blank: "The sun rises in the ____."',
      score: 10,
      type: 'fill_in_the_blank',
      dateCreated: '29/01/2024',
      answers: [
        BasicAnswerModel( content: 'East', isCorrect: true),
      ],
    ),
  ];

  @override
  Future<Either> addQuestionService(QuestionPayload question) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.post('http://localhost:5000/api/question', question.toMap());
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
  Future<Either> deleteQuestionService() {
    // TODO: implement deleteQuestionService
    throw UnimplementedError();
  }

  @override
  Future<Either> editQuestionService(EditQuestionPayloadModel question) async {
    try {

      final apiService = sl<ApiService>();
      final response = await apiService.put('http://localhost:5000/api/question/${question.id}', question.toMap());
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
      final response = await apiService.get('http://localhost:5000/api/quiz/practice/${quizId}');
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
      final response = await apiService.get('http://localhost:5000/api/question/get-my-question?name=${searchSort.name}&sortField=${searchSort.sortField}&sortOrder=${searchSort.direction}');
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