import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/quiz/models/quiz_quetion_payload.dart';

import '../../../data/quiz/models/edit_quiz_model.dart';
import '../../../data/quiz/models/quiz_payload_model.dart';

abstract class QuizRepository{
  Future<Either> addQuiz(QuizPayloadModel quiz);
  Future<Either> addQuestionToQuiz(QuizQuestionPayload quizQues);
  Future<Either> editQuizDetail(EditQuizModel quiz);
  Future<Either> getHotQuiz();
  Future<Either> getListMyQuiz();
  Future<Either> getListQuizOfTeam();
  Future<Either> getNewestQuiz();
  Future<Either> getQuizDetail(String id);
  Future<Either> getRecentQuiz();
  Future<Either> removeQuestionFromQuiz(QuizQuestionPayload quizQues);
  Future<Either> searchListQuiz();
  Future<Either> getAllTopic();
}