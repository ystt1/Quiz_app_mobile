import 'package:flutter/material.dart';
import 'package:quiz_app/common/widgets/build_avatar.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

import '../pages/chatting_page.dart';

class FriendListTab extends StatelessWidget {
  final List<SimpleUserEntity> friends;
  const FriendListTab({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search friends...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {

            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              var friend = friends[index];
              return ListTile(
                leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Base64ImageWidget(base64String: friend.avatar,),
                  ),
                ),
                title: Text(friend.email),
                subtitle: const Text("Active now"),
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChattingPage(user: friend,),
                  ),
                );},
              );
            },
          ),
        ),
      ],
    );
  }
}
