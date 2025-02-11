import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_2.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit_2.dart';
import 'package:quiz_app/common/widgets/comment_card.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/data/post/models/comment_payload_modal.dart';
import 'package:quiz_app/domain/post/entity/post_entity.dart';
import 'package:quiz_app/domain/post/usecase/add_comment_usecase.dart';
import 'package:quiz_app/presentation/team/bloc/get_list_comment_cubit.dart';
import 'package:quiz_app/presentation/team/bloc/get_list_comment_state.dart';
import 'package:quiz_app/presentation/team/bloc/get_list_post_cubit.dart';

import '../../domain/post/entity/comment_entity.dart';

class CommentModal extends StatefulWidget {
  final BuildContext context;
  final PostEntity? post;
  final String? idQuiz;
  final String? idTeam;
  const CommentModal({super.key, this.idQuiz,this.idTeam, this.post, required this.context});

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  TextEditingController commentController = TextEditingController();
  CommentEntity? replyingTo;
  String sortType = "newest";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetListCommentCubit()
          ..onGet(CommentPayloadModal(
            parent: "",
            content: "",
            post: widget.post?.id ?? "",
            idQuiz: widget.idQuiz ?? "",
            sortType: sortType,
          ))),
        BlocProvider(create: (_) => ButtonStateCubit()),
        BlocProvider(create: (_) => ButtonStateCubit2()),
      ],
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: GetFailure(name: state.errorMessage)));
          }
          if (state is ButtonSuccessState) {
            context.read<GetListCommentCubit>().onGet(CommentPayloadModal(
              parent: "",
              content: "",
              post: widget.post?.id ?? "",
              idQuiz: widget.idQuiz ?? "",
              sortType: sortType,
            ));
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút đóng modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Comments",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 40), // Để căn giữa tiêu đề
                ],
              ),

              // Chọn kiểu sắp xếp comment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sort by:", style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: sortType,
                    items: const [
                      DropdownMenuItem(value: "newest", child: Text("Newest")),
                      DropdownMenuItem(value: "most_replies", child: Text("Most Replies")),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          sortType = newValue;
                        });
                        context.read<GetListCommentCubit>().onGet(
                          CommentPayloadModal(
                            parent: "",
                            content: "",
                            post: widget.post?.id ?? "",
                            idQuiz: widget.idQuiz ?? "",
                            sortType: sortType,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),


              BlocBuilder<GetListCommentCubit, GetListCommentState>(
                builder: (context, state) {
                  if (state is GetListCommentFailure) {
                    return Expanded(child: GetFailure(name: state.error));
                  }
                  if (state is GetListCommentSuccess) {
                    if (state.comments.isEmpty) {
                      return const Expanded(
                        child: Center(
                          child: Text(
                            "Be the first to comment!",
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) {
                          return CommentCard(
                            idTeam: widget.idTeam,
                            idQuiz: widget.idQuiz,
                            post: widget.post,
                            comment: state.comments[index],
                            onReply: (comment) {
                              setState(() {
                                replyingTo = comment;
                              });
                            },
                          );
                        },
                      ),
                    );
                  }
                  return Expanded(child: const GetLoading());
                },
              ),
              if (replyingTo != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Replying to @${replyingTo!.user.email}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            replyingTo = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // Ô nhập comment
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "Add a comment...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  suffixIcon: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          context.read<ButtonStateCubit>().execute(
                            usecase: AddCommentUseCase(),
                            params: CommentPayloadModal(
                              idQuiz: widget.idQuiz ?? "",
                              post: widget.post?.id,
                              parent: replyingTo?.id ?? "",
                              content: commentController.text,
                              sortType: sortType,
                            ),
                          );
                          setState(() {
                            commentController.clear();
                            replyingTo = null;
                          });
                        },
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
