import 'package:quiz_app/data/conversation/models/message_model.dart';

abstract class GetChattingState{}

class GetChattingLoading extends GetChattingState{
}

class GetChattingFailure extends GetChattingState{
  final String error;

  GetChattingFailure({required this.error});
}

class GetChattingSuccess extends GetChattingState{
  final List<MessageModel> messages;

  GetChattingSuccess({required this.messages});
}