import 'package:flutter/material.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/core/global_storage.dart';
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Base64ImageWidget(
                base64String: conversation.user.avatar,
              ),
            ),
          ),
          title: Text(conversation.user.email),
          subtitle: Row(
            children: [
              Expanded(
                  child: FutureBuilder<String?>(
                    future: GlobalStorage.getUserId(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator(); // Loading state

                      final userId = snapshot.data ?? ""; // Lấy userId từ Future

                      return Text(
                        (conversation.lastMessage.sender == userId ? "You: " : "") +
                            conversation.lastMessage.content,maxLines: 1,overflow: TextOverflow.ellipsis,
                      );
                    },
                  )
              ),
              Text(AppHelper.timeAgo(conversation.lastMessage.createdAt))
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChattingPage(
                  user: conversation.user,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
