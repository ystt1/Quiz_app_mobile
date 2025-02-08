import 'package:flutter/material.dart';
import 'package:quiz_app/domain/conversation/entity/conversation_entity.dart';
import 'package:quiz_app/presentation/friend/pages/chatting_page.dart';

import '../../../common/widgets/build_base_64_image.dart';

class ConversationTab extends StatelessWidget {
  final List<ConversationEntity> conversations;

  const ConversationTab({super.key, required this.conversations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        var conversation = conversations[index];
        return ListTile(
          leading: CircleAvatar(
            child: Base64ImageWidget(
              base64String: conversation.user.avatar,
            ),
          ),
          title: Text(conversation.user.email),
          subtitle: Text(conversation.lastMessage),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChattingPage(user: conversation.user,),
              ),
            );
          },
        );
      },
    );
  }
}
