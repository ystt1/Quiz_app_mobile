import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/question/models/question_payload_model.dart';

import '../../../data/question/models/edit_question_payload_model.dart';

abstract class QuestionRepository{
  Future<Either> addQuestion(QuestionPayload question);
  Future<Either> deleteQuestion();
  Future<Either> editQuestion(EditQuestionPayloadModel question);
  Future<Either> getListQuestion();
  Future<Either> getQuestionDetail();
  Future<Either> getMyQuestion();
}