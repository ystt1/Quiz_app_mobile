

import 'package:quiz_app/domain/quiz/entity/result_entity.dart';

abstract class GetListResultState{}
class GetListResultInitialState extends GetListResultState{}
class GetListResultLoading extends GetListResultState{}

class GetListResultSuccess extends GetListResultState{
  final List<ResultEntity> results;
  GetListResultSuccess({required this.results});
}
class GetListResultFailure extends GetListResultState{
  final String error;
  GetListResultFailure({required this.error});
}


