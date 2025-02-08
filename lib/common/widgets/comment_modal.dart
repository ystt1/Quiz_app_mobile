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
import '../../domain/post/usecase/like_post_usecase.dart';

class CommentModal extends StatefulWidget {
  final BuildContext context;
  final PostEntity? post;
  final String? idQuiz;

  const CommentModal(
      {super.key, this.idQuiz, this.post, required this.context});

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  TextEditingController commentController = TextEditingController();
  CommentEntity? replyingTo;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) {
          print(widget.idQuiz);
          if (widget.post == null && widget.idQuiz == null) {
            throw Exception("Post ID và Quiz ID không được null");
          }
          return GetListCommentCubit()
            ..onGet(CommentPayloadModal(
              parent: "",
              content: "",
              post: widget.post?.id ?? "",
              idQuiz: widget.idQuiz ?? "",
            ));
        }),
        BlocProvider(create: (BuildContext context) => ButtonStateCubit()),
        BlocProvider(create: (BuildContext context) => ButtonStateCubit2()),
      ],
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (BuildContext context, ButtonState state) {
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
            ));
          }
        },
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocListener<ButtonStateCubit2, ButtonState2>(
                      listener: (BuildContext context, btnState) {
                        if (btnState is ButtonSuccessState2) {
                          if (widget.post != null) {
                            widget.context
                                .read<GetListPostCubit>()
                                .likePost(widget.post!.id);
                          }
                        }
                        if (btnState is ButtonFailureState2) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  GetFailure(name: btnState.errorMessage)));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.post != null
                              ? IconButton(
                                  icon: Icon(Icons.favorite_border,
                                      color: widget.post!.statusLike == true
                                          ? Colors.red
                                          : null),
                                  onPressed: () {
                                    context.read<ButtonStateCubit2>().execute(
                                        usecase: LikePostUseCase(),
                                        params: widget.post!.id);
                                  },
                                )
                              : SizedBox(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      )),
                  const SizedBox(height: 10),
                  BlocBuilder<GetListCommentCubit, GetListCommentState>(
                    builder: (context, state) {
                      if (state is GetListCommentLoading) {
                        return GetLoading();
                      }
                      if (state is GetListCommentFailure) {
                        return GetFailure(name: state.error);
                      }
                      if (state is GetListCommentSuccess) {
                        if (widget.post != null) {
                          widget.context.read<GetListPostCubit>().updatePost(
                              PostEntity(
                                  id: widget.post!.id,
                                  content: widget.post!.content,
                                  creator: widget.post!.creator,
                                  createdAt: widget.post!.createdAt,
                                  likeCount: widget.post!.likeCount,
                                  commentCount: state.comments.length,
                                  image: widget.post!.image,
                                  quiz: widget.post!.quiz,
                                  statusLike: widget.post!.statusLike));
                        }
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.comments.length,
                            itemBuilder: (context, index) {
                              return CommentCard(
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
                      return GetSomethingWrong();
                    },
                  ),
                  if (replyingTo != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue[100],
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
                  Builder(builder: (context) {
                    return TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        labelText: "Add a comment...",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            context.read<ButtonStateCubit>().execute(
                                usecase: AddCommentUseCase(),
                                params: CommentPayloadModal(
                                    idQuiz:widget.idQuiz??"",
                                    post: widget.post?.id,
                                    parent: replyingTo?.id ?? "",
                                    content: commentController.text));
                            setState(() {
                              commentController.clear();
                              replyingTo = null;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
