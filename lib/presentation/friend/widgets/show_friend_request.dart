import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:quiz_app/presentation/friend/bloc/get_friend_request_cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/button/button_state_cubit.dart';
import '../../../common/widgets/build_avatar.dart';
import '../../../common/widgets/get_failure.dart';
import '../../../domain/user/usecase/accept_friend_request_usecase.dart';
import '../bloc/get_friend_cubit.dart';

class ShowFriendRequest extends StatefulWidget {

  final BuildContext parentContext;
  final List<SimpleUserEntity> user;
  const ShowFriendRequest({super.key, required this.parentContext, required this.user});

  @override
  State<ShowFriendRequest> createState() => _ShowFriendRequestState();
}

class _ShowFriendRequestState extends State<ShowFriendRequest> {
  late List<SimpleUserEntity> user;
  @override
  void initState() {
   user=widget.user;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ButtonStateCubit(),
      child: StatefulBuilder(
        builder: (BuildContext context,StateSetter modalSetState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: buildAvatar(user[index].avatar),
                      title: Text(user[index].email),
                      trailing: Wrap(
                        children: [
                          BlocListener<ButtonStateCubit, ButtonState>(
                            listener: (BuildContext context, ButtonState state) {

                              if (state is ButtonFailureState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: GetFailure(
                                            name: state.errorMessage)));
                              }
                              if (state is ButtonSuccessState) {
                                if(state.type != null)
                                  {

                                  }

                                if (state.type == "accept") {
                                  widget.parentContext
                                      .read<GetFriendCubit>()
                                      .onAdd(user.elementAt(state.index!));
                                  widget.parentContext
                                      .read<GetFriendRequestCubit>()
                                      .onRemove(user.elementAt(state.index!));
                                  modalSetState(() {
                                    user=widget.user;
                                  });
                                }
                              }
                            },
                            child: IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                context.read<ButtonStateCubit>().execute(
                                    usecase: AcceptFriendRequestUseCase(),
                                    params: user[index].id,
                                    type: "accept",
                                    index: index);
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => {},
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: user.length),
            ],
          );
        },


      ),
    );
  }
}
