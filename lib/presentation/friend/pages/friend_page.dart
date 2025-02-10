import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/conversation/get_list_conversation_cubit.dart';
import 'package:quiz_app/common/bloc/conversation/get_list_conversaton_state.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/conversation/usecase/get_list_conversation_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_friend_request_usecase.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_cubit.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_request_cubit.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_request_state.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_state.dart';
import 'package:quiz_app/presentation/friend/widgets/conversation_tab.dart';
import 'package:quiz_app/presentation/friend/widgets/friend_list_tab.dart';
import 'package:quiz_app/presentation/friend/widgets/header.dart';

import '../../../common/widgets/center_text.dart';
import '../../../domain/user/usecase/get_friend_usecase.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);



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
                ..onGet(useCase: GetFriendUseCase(),params: "")),
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
            body: RefreshIndicator(

              onRefresh: ()async {
                context.read<GetFriendRequestCubit>().onGet(useCase: GetFriendRequestUseCase());
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  BlocBuilder<GetListConversationCubit,GetListConversationState>(
                    builder: (BuildContext context, GetListConversationState state) {
                      if(state is GetListConversationLoading)
                        {
                          return GetLoading();
                        }
                      if(state is GetListConversationFailure)
                        {
                          return GetFailure(name: state.error);
                        }
                      if(state is GetListConversationSuccess)
                        {
                          if(state.conversations.isEmpty)
                          {
                            return const CenterText(text: "You don't have any conversation yet");
                          }
                          return ConversationTab(conversations: state.conversations,);
                        }
                      return GetSomethingWrong();
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
              
                            return GetFailure(name: state.error);
                          }
                        if(state is GetFriendSuccess)
                          {
                            if(state.users.isEmpty)
                            {
                              return const CenterText(text: "Not found any friend");
                            }
                            return FriendListTab(friends: state.users);
                          }
                        return GetSomethingWrong();
                      },
                      );
                    }
                  )
                ],
              ),
            ),
        
        ));
  }
}
