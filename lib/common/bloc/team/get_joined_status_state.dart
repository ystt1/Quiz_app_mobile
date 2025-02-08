import 'package:quiz_app/domain/team/entity/join_request_entity.dart';

abstract class GetJoinedStatusState{}

class GetJoinedStatusLoading extends GetJoinedStatusState{
}

class GetJoinedStatusSuccess extends GetJoinedStatusState{
  final List<JoinRequestEntity> requests;

  GetJoinedStatusSuccess({required this.requests});
}

class GetJoinedStatusFailure extends GetJoinedStatusState{
  final String error;

  GetJoinedStatusFailure({required this.error});
}