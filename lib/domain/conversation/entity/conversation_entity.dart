import 'package:quiz_app/data/conversation/models/conversation_model.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class ConversationEntity{
  final String conversationId;
  final SimpleUserEntity user;
  final String lastMessage;
  final String createdAt;

  ConversationEntity({required this.conversationId, required this.user, required this.lastMessage, required this.createdAt});
}