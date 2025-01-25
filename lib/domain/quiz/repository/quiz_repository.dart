import 'package:dartz/dartz.dart';

abstract class QuizRepository{
  Future<Either> addQuiz();
  Future<Either> addQuestionToQuiz();
  Future<Either> editQuizDetail();
  Future<Either> getHotQuiz();
  Future<Either> getListMyQuiz();
  Future<Either> getListQuizOfTeam();
  Future<Either> getNewestQuiz();
  Future<Either> getQuizDetail();
  Future<Either> getRecentQuiz();
  Future<Either> removeQuestionFromQuiz();
  Future<Either> searchListQuiz();
  Future<Either> getAllTopic();
}