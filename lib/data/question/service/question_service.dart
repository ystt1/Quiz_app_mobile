import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/question/models/basic_answer_model.dart';
import 'package:quiz_app/data/question/models/basic_question_model.dart';

abstract class QuestionService{
  Future<Either> addQuestionService();
  Future<Either> deleteQuestionService();
  Future<Either> editQuestionService();
  Future<Either> getListQuestionService();
  Future<Either> getQuestionDetailService();
}

class QuestionServiceImp extends QuestionService {

  final mockQuestions = [
    BasicQuestionModel(
      id: 'q1',
      content: 'What is the capital of France?',
      score: '10',
      type: 'multiple_choice',
      answers: [
        BasicAnswerModel(id: 'a1', content: 'Paris', isCorrect: true),
        BasicAnswerModel(id: 'a2', content: 'Berlin', isCorrect: false),
        BasicAnswerModel(id: 'a3', content: 'Madrid', isCorrect: false),
        BasicAnswerModel(id: 'a4', content: 'Rome', isCorrect: false),
      ], dateCreated: '29/01/2024',
    ),
    BasicQuestionModel(
      id: 'q2',
      content: 'Which programming language is used for Flutter development?',
      score: '15',
      type: 'single_choice',
      dateCreated: '29/01/2024',
      answers: [
        BasicAnswerModel(id: 'a1', content: 'Java', isCorrect: false),
        BasicAnswerModel(id: 'a2', content: 'Python', isCorrect: false),
        BasicAnswerModel(id: 'a3', content: 'Dart', isCorrect: true),
        BasicAnswerModel(id: 'a4', content: 'C++', isCorrect: false),
      ],
    ),
    BasicQuestionModel(
      id: 'q3',
      content: 'Select all prime numbers below:',
      score: '20',
      type: 'multiple_selection',
      dateCreated: '29/01/2024',
      answers: [
        BasicAnswerModel(id: 'a1', content: '2', isCorrect: true),
        BasicAnswerModel(id: 'a2', content: '4', isCorrect: false),
        BasicAnswerModel(id: 'a3', content: '5', isCorrect: true),
        BasicAnswerModel(id: 'a4', content: '8', isCorrect: false),
      ],
    ),
    BasicQuestionModel(
      id: 'q4',
      content: 'Fill in the blank: "The sun rises in the ____."',
      score: '10',
      type: 'fill_in_the_blank',
      dateCreated: '29/01/2024',
      answers: [
        BasicAnswerModel(id: 'a1', content: 'East', isCorrect: true),
      ],
    ),
  ];

  @override
  Future<Either> addQuestionService() {
    // TODO: implement addQuestionService
    throw UnimplementedError();
  }

  @override
  Future<Either> deleteQuestionService() {
    // TODO: implement deleteQuestionService
    throw UnimplementedError();
  }

  @override
  Future<Either> editQuestionService() {
    // TODO: implement editQuestionService
    throw UnimplementedError();
  }

  @override
  Future<Either> getListQuestionService() async {
    try{
      return Right(mockQuestions);
    }
        catch (e)
    {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getQuestionDetailService() {
    // TODO: implement getQuestionDetailService
    throw UnimplementedError();
  }

}