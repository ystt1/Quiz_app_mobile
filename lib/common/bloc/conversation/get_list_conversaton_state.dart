import 'package:quiz_app/domain/conversation/entity/conversation_entity.dart';

abstract class GetListConversationState{}

class GetListConversationLoading extends GetListConversationState{}

class GetListConversationSuccess extends GetListConversationState{
  final List<ConversationEntity> conversations;

  GetListConversationSuccess({required this.conversations});
}

class GetListConversationFailure extends GetListConversationState{
  final String error;

  GetListConversationFailure({required this.error});
  
}