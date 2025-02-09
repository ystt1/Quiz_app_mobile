import 'package:quiz_app/data/conversation/models/message_model.dart';
import 'package:quiz_app/data/user/model/simple_user_model.dart';
import 'package:quiz_app/domain/conversation/entity/conversation_entity.dart';

class ConversationModel {
  final String conversationId;
  final SimpleUserModel user;
  final MessageModel lastMessage;
  final String createdAt;

  ConversationModel({
    required this.conversationId,
    required this.user,
    required this.createdAt,
    required this.lastMessage
  });


  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      conversationId: map['conversationId'] as String,
      user: SimpleUserModel.fromMap(map['user']),
      lastMessage: MessageModel.fromMap(map['lastMessage']) ,
      createdAt: map['createdAt'] as String,
    );
  }
}

extension ConversationModelToEntity on ConversationModel {
  ConversationEntity toEntity() {
    return ConversationEntity(
        conversationId: conversationId,
        user: user.toEntity(),
        lastMessage: lastMessage,
        createdAt: createdAt);
  }
}
