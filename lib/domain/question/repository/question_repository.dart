import 'package:dartz/dartz.dart';

abstract class QuestionRepository{
  Future<Either> addQuestion();
  Future<Either> deleteQuestion();
  Future<Either> editQuestion();
  Future<Either> getListQuestion();
  Future<Either> getQuestionDetail();
}