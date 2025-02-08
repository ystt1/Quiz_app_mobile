import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/core/global_storage.dart';
import 'package:quiz_app/domain/conversation/entity/conversation_entity.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:quiz_app/presentation/friend/bloc/get_chatting_cubit.dart';
import 'package:quiz_app/presentation/friend/bloc/get_chatting_state.dart';

class ChattingPage extends StatefulWidget {
  final SimpleUserEntity user;

  const ChattingPage({super.key, required this.user});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  TextEditingController _controller = TextEditingController();
  String id = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    id = (await GlobalStorage.getUserId())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tin nhắn")),
      body: BlocProvider(
        create: (BuildContext context) =>
            GetChattingCubit()..onGet(widget.user.id),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<GetChattingCubit, GetChattingState>(
                builder: (BuildContext context, GetChattingState state) {
                  if (state is GetChattingLoading) {
                    return GetLoading();
                  }
                  if (state is GetChattingFailure) {
                    return GetFailure(name: state.error);
                  }
                  if (state is GetChattingSuccess) {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.sender == id;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color:
                                  isMe ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message.content,
                              style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return GetSomethingWrong();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Nhập tin nhắn...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        context.read<GetChattingCubit>().onSendMessage(
                              _controller.text,
                              widget.user.id,
                            );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
