import 'package:quiz_app/data/user/model/simple_user_model.dart';

class MessageModel {
  final String conversationId;
  final String messageId;
  final String content;
  final String sender;
  final String createdAt;

  MessageModel({required this.conversationId, required this.messageId, required this.content, required this.sender, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'conversationId': this.conversationId,
      'messageId': this.messageId,
      'content': this.content,
      'sender': this.sender,
      'createdAt': this.createdAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      conversationId: map['conversationId'] ?? "",
      messageId: map['_id'] ?? "",
      content: map['content'] ?? "",
      sender: map['senderId'],
      createdAt: map['sentAt'] ?? "",
    );
  }
}
