import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/conversation/get_list_conversation_cubit.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_cubit.dart';
import 'package:quiz_app/common/widgets/qr_page.dart';
import 'package:quiz_app/domain/conversation/usecase/get_list_conversation_usecase.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:quiz_app/domain/user/usecase/get_friend_usecase.dart';
import 'package:quiz_app/presentation/friend/pages/search_friend.dart';
import 'package:quiz_app/presentation/friend/widgets/show_friend_request.dart';

import '../../../domain/user/usecase/get_friend_request_usecase.dart';
import '../bloc/get_friend_cubit.dart';
import '../bloc/get_friend_request_cubit.dart';

class AppBarHeaderFriendPage extends StatefulWidget {
  final List<SimpleUserEntity> friendRequest;
  final TabController tabController;

  const AppBarHeaderFriendPage(
      {super.key, required this.friendRequest, required this.tabController});

  @override
  State<AppBarHeaderFriendPage> createState() => _AppBarHeaderFriendPageState();
}

class _AppBarHeaderFriendPageState extends State<AppBarHeaderFriendPage> {
  @override
  Widget build(BuildContext context) {
    void _showFriendRequests(BuildContext context) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context2) {
            return ShowFriendRequest(
              parentContext: context,
              user: widget.friendRequest,
            );
          });
    }

    return AppBar(
      title: const Text('Friends'),
      bottom: TabBar(
        controller: widget.tabController,
        tabs: const [
          Tab(icon: Icon(Icons.message), text: "Messages"),
          Tab(icon: Icon(Icons.people), text: "Friends"),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              context
                  .read<GetFriendRequestCubit>()
                  .onGet(useCase: GetFriendRequestUseCase());
              context
                  .read<GetListConversationCubit>()
                  .onGet(usecase: GetListConversationUseCase());
              context
                  .read<GetFriendCubit>()
                  .onGet(useCase: GetFriendUseCase(),params:'');
            },
            icon: Icon(Icons.refresh)),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SearchFriend()),
            );
          },
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                widget.friendRequest.isNotEmpty
                    ? _showFriendRequests(context)
                    : {};
              },
            ),
            if (widget.friendRequest.isNotEmpty)
              Positioned(
                right: 10,
                top: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 8,
                  child: Text(
                    widget.friendRequest.length.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => GetUserDetailCubit(),
                  child: ScanQrPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
