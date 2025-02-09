import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/build_avatar.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/click_user_detail.dart';
import 'package:quiz_app/common/widgets/comment_modal.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/text_expandable.dart';
import 'package:quiz_app/domain/post/entity/post_entity.dart';
import 'package:quiz_app/domain/post/usecase/like_post_usecase.dart';
import 'package:quiz_app/presentation/quiz/pages/practice_quiz_detail_page.dart';
import 'package:quiz_app/presentation/team/bloc/get_list_post_cubit.dart';

import '../helper/app_helper.dart';

class PostCard extends StatefulWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      onClickUser(context, widget.post.creator.id);
                    },
                    child: CircleAvatar(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Base64ImageWidget(
                              base64String: widget.post.creator.avatar)),
                    )),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    onClickUser(context, widget.post.creator.id);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.creator.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        AppHelper.timeAgo(widget.post.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ExpandableText(text: widget.post.content),
            if (widget.post.image != '')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: 300,
                  child: Base64ImageWidget(
                    base64String: widget.post.image,
                  ),
                ),
              ),
            if (widget.post.quiz.id != '')
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), // Bo góc
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PracticeQuizDetailPage(
                                quizId: widget.post.quiz.id)),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12)), // Bo tròn ảnh trên
                            child: Base64ImageWidget(
                              base64String: widget.post.quiz.image,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.post.quiz.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocProvider(
                  create: (BuildContext context) => ButtonStateCubit(),
                  child: Row(
                    children: [
                      BlocListener<ButtonStateCubit, ButtonState>(
                        listener: (BuildContext context, state) {
                          if (state is ButtonFailureState) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: GetFailure(name: state.errorMessage)));
                          }
                          if (state is ButtonSuccessState) {
                            context
                                .read<GetListPostCubit>()
                                .likePost(widget.post.id);
                          }
                        },
                        child: Builder(builder: (context) {
                          return IconButton(
                            icon: Icon(Icons.favorite_border,
                                color: widget.post.statusLike == true
                                    ? Colors.red
                                    : null),
                            onPressed: () {
                              context.read<ButtonStateCubit>().execute(
                                  usecase: LikePostUseCase(),
                                  params: widget.post.id);
                            },
                          );
                        }),
                      ),
                      Text('${widget.post.likeCount}'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context2) {
                          return CommentModal(
                            context: context,
                            post: widget.post,
                          );
                        });
                  },
                  child: Text(
                    'Comments (${widget.post.commentCount})',
                    style: const TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
