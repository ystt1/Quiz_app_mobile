import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/user/usecase/get_friend_request_usecase.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_cubit.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_request_cubit.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_request_state.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_state.dart';
import 'package:quiz_app/presentation/friend/widgets/friend_list_tab.dart';
import 'package:quiz_app/presentation/friend/widgets/header.dart';

import '../../../domain/user/usecase/get_friend_usecase.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);


  List<Map<String, String>> friends = [
    {
      'name': 'John Doe',
      'avatar': 'https://via.placeholder.com/50',
      'lastMessage': 'Hey, how are you?'
    },
    {
      'name': 'Jane Smith',
      'avatar': 'https://via.placeholder.com/50',
      'lastMessage': 'See you soon!'
    },
    {
      'name': 'Mike Johnson',
      'avatar': 'https://via.placeholder.com/50',
      'lastMessage': 'Let’s catch up later!'
    },
  ];

  List<Map<String, String>> friendRequests = [
    {'name': 'Alice Brown', 'avatar': 'https://via.placeholder.com/50'},
    {'name': 'Bob Green', 'avatar': 'https://via.placeholder.com/50'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => GetFriendRequestCubit()
                ..onGet(useCase: GetFriendRequestUseCase())),
          BlocProvider(
              create: (_) => GetFriendCubit()
                ..onGet(useCase: GetFriendUseCase())),
          BlocProvider(
              create: (_) => ButtonStateCubit()
                ),
        ],
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: BlocConsumer<GetFriendRequestCubit, GetFriendRequestState>(
              builder: (BuildContext context, GetFriendRequestState state) {
                if (state is GetFriendRequestSuccess) {
                  return AppBarHeaderFriendPage(
                    friendRequest: state.users,
                    tabController: _tabController,
                  );
                }
                return GetLoading();
              },
              listener: (BuildContext context, GetFriendRequestState state) {
                if (state is GetFriendRequestFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: GetFailure(name: state.error)));
                }
              },
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              /// **Tab 1: Danh sách tin nhắn**
              ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  var friend = friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                        child: Base64ImageWidget(base64String: "",),),
                    title: Text(friend['name']!),
                    subtitle: Text(friend['lastMessage']!),
                    onTap: () {},
                  );
                },
              ),


              Builder(
                builder: (context) {
                  return BlocBuilder<GetFriendCubit,GetFriendState>(builder: (BuildContext context, state) {
                    if(state is GetFriendLoading)
                      {
                        return GetLoading();
                      }
                    if(state is GetFriendFailure)
                      {
                        print(state.error);
                        return GetFailure(name: state.error);
                      }
                    if(state is GetFriendSuccess)
                      {
                        return FriendListTab(friends: state.users);
                      }
                    return GetSomethingWrong();
                  },
                  );
                }
              )
            ],
          ),
        ));
  }
}
