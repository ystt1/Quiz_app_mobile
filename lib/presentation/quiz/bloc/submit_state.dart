import 'package:quiz_app/domain/quiz/entity/result_entity.dart';

abstract class SubmitState{}

class SubmitLoading extends SubmitState{
}

class SubmitSuccess extends SubmitState{
  final ResultEntity result;

  SubmitSuccess({required this.result});
}

class SubmitFailure extends SubmitState{
  final String error;

  SubmitFailure({required this.error});
}