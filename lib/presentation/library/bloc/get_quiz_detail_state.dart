import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';


abstract class GetQuizDetailState{}

class GetQuizDetailLoading extends GetQuizDetailState{}

class GetQuizDetailSuccess extends GetQuizDetailState{
  final BasicQuizEntity quiz;
  String? flag;
  GetQuizDetailSuccess({required this.quiz,required this.flag});

}

class GetQuizDetailFailure extends GetQuizDetailState{
  final String error;

  GetQuizDetailFailure({required this.error});
}