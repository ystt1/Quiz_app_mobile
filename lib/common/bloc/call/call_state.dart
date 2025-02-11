import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

abstract class CallState{
}
class CallStateInitial extends CallState{

}
class CallStateLoading extends CallState{
  final SimpleUserEntity user;
  final String signal_sdp;
  final String signal_type;
  CallStateLoading({required this.user,required this.signal_sdp,required this.signal_type});
}

class CallStateWaiting extends CallState{
  final SimpleUserEntity user;

  CallStateWaiting({required this.user});
}


class CallStateSuccess extends CallState{
  final SimpleUserEntity user;

  CallStateSuccess({required this.user});
}