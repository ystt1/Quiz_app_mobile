import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/question/models/question_payload_model.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';

import '../../../data/question/models/edit_question_payload_model.dart';

abstract class QuestionRepository{
  Future<Either> addQuestion(QuestionPayload question);
  Future<Either> deleteQuestion(String id);
  Future<Either> editQuestion(EditQuestionPayloadModel question);
  Future<Either> getListQuestion(String quizId);
  Future<Either> getQuestionDetail();
  Future<Either> getMyQuestion(SearchAndSortModel searchSort);
}