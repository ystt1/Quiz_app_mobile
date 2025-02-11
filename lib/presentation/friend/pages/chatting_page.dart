import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/call/call_cubit.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/common/helper/get_img_string.dart';
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
  String image = '';
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
      appBar: AppBar(
        title: Text("Tin nhắn"),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                  onPressed: () {
                    context.read<CallCubit>().startCall(widget.user);
                  },
                  icon: Icon(Icons.call));
            }
          )
        ],
      ),
      body: BlocProvider(
        create: (BuildContext context) =>
            GetChattingCubit()..onGet(widget.user.id),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<GetChattingCubit, GetChattingState>(
                builder: (BuildContext context, GetChattingState state) {
                  if (state is GetChattingLoading)
                    return GetFailure(name: "Not have any message");
                  if (state is GetChattingFailure) {
                    return GetFailure(name: state.error);
                  }
                  if (state is GetChattingSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.sender == id;
                        return Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isMe)
                              CircleAvatar(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(45),
                                    child: Base64ImageWidget(
                                      base64String: widget.user.avatar,
                                    )),
                              ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  constraints: BoxConstraints(maxWidth: 250),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Colors.blueAccent
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: isMe
                                          ? Radius.circular(12)
                                          : Radius.zero,
                                      bottomRight: isMe
                                          ? Radius.zero
                                          : Radius.circular(12),
                                    ),
                                  ),
                                  child: message.type == 'image'
                                      ? Base64ImageWidget(
                                          base64String: message.content,
                                        )
                                      : Text(
                                          message.content,
                                          style: TextStyle(
                                              color: isMe
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  AppHelper.timeAgo(message.createdAt),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600]), // Màu xám nhạt
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
            if (image != '')
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                            height: 150,
                            child: Base64ImageWidget(
                              base64String: image,
                            )),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(60)),
                            alignment: Alignment.center,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  image = '';
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        String? base64Image = await getImgString();
                        if (base64Image != null) {
                          setState(() {
                            image = base64Image;
                          });
                        }
                      },
                      icon: Icon(Icons.image)),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Enter message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (image != '') {
                          context
                              .read<GetChattingCubit>()
                              .onSendMessage(image, widget.user.id, "image");
                          setState(() {
                            image = '';
                          });
                        }
                        if (_controller.text.trim().isNotEmpty) {
                          context.read<GetChattingCubit>().onSendMessage(
                              _controller.text.trim(), widget.user.id, "text");
                          _controller.clear();
                        }
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
