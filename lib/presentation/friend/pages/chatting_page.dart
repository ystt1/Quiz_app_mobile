import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
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
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    id = (await GlobalStorage.getUserId())!;
    setState(() {});
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
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
                  if (state is GetChattingLoading) return GetLoading();
                  if (state is GetChattingFailure) return GetFailure(name: state.error);
                  if (state is GetChattingSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      _scrollToBottom();
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.sender == id;
                        return Row(
                          mainAxisAlignment:
                          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isMe)
                              CircleAvatar(
                                child: ClipRRect(borderRadius: BorderRadius.circular(45),
                                    child: Base64ImageWidget(base64String: widget.user.avatar,)),
                              ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment:
                              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  constraints: BoxConstraints(maxWidth: 250),
                                  decoration: BoxDecoration(
                                    color: isMe ? Colors.blueAccent : Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                                      bottomRight: isMe ? Radius.zero : Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  AppHelper.timeAgo(message.createdAt),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]), // Màu xám nhạt
                                ),
                              ],
                            ),
                          ],
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
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          if (_controller.text.trim().isNotEmpty) {
                            context.read<GetChattingCubit>().onSendMessage(
                              _controller.text.trim(),
                              widget.user.id,
                            );
                            _scrollToBottom();
                            _controller.clear();
                            Future.delayed(Duration(milliseconds: 300), _scrollToBottom);
                          }
                        },
                      );
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

