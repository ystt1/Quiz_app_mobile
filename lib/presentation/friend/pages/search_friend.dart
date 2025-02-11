import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/user/get_list_user_cubit.dart';
import 'package:quiz_app/common/bloc/user/get_list_user_state.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/domain/user/usecase/get_list_user_usecase.dart';
import 'package:quiz_app/presentation/team/pages/user_detail_modal.dart';

class SearchFriend extends StatefulWidget {
  const SearchFriend({super.key});

  @override
  State<SearchFriend> createState() => _SearchFriendState();
}

class _SearchFriendState extends State<SearchFriend> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GetListUserCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Search Friends")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Search by email",
                  suffixIcon: Builder(builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        context.read<GetListUserCubit>().onGet(
                            usecase: GetListUserUseCase(),
                            params: _controller.text);
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<GetListUserCubit, GetListUserState>(
                  builder: (BuildContext context, state) {
                    if (state is GetListUserLoading) {
                      return const GetLoading();
                    }
                    if (state is GetListUserFailure) {
                      return GetFailure(name: state.error);
                    }
                    if (state is GetListUserSuccess) {
                      return ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserModalPage(
                                      userId: state.users[index].id)));
                            },
                            child: ListTile(
                                leading: CircleAvatar(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Base64ImageWidget(
                                      base64String: state.users[index].avatar,
                                    ),
                                  ),
                                ),
                                title: Text(state.users[index].email),
                                subtitle:
                                    Text(state.users[index].friendshipStatus)),
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text("You didn't search some thing"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
