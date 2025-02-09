import 'package:flutter/material.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/common/widgets/build_avatar.dart';
import 'package:quiz_app/common/widgets/text_expandable.dart';
import 'package:quiz_app/domain/post/entity/comment_entity.dart';
import 'package:quiz_app/domain/post/entity/post_entity.dart';

class CommentCard extends StatefulWidget {
  final PostEntity? post;
  final CommentEntity comment;
  final Function(CommentEntity) onReply;
  final bool? isReply;
  final String? idQuiz;
  const CommentCard({
    super.key,
    this.idQuiz,
    this.post,
    required this.comment,
    required this.onReply, this.isReply=false,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  buildAvatar(widget.comment.user.avatar),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.user.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),


              ExpandableText(text: widget.comment.content),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row(
                  //   children: [
                  //     IconButton(
                  //       icon: const Icon(Icons.favorite_border),
                  //       onPressed: () {},
                  //     ),
                  //     Text(widget.comment.toString()),
                  //   ],
                  // ),
                  widget.isReply==false? TextButton(
                    onPressed: () => widget.onReply(widget.comment),
                    child: const Text("Reply"),
                  ):SizedBox(),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Visibility(
                  visible: widget.comment.replies.isNotEmpty,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        showReplies = !showReplies;
                      });
                    },
                    child: Text(showReplies
                        ? "Hide replies"
                        : "View ${widget.comment.replies.length} replies"),
                  ),
                ),
              Text(
                AppHelper.timeAgo(widget.comment.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        if (showReplies)
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Column(
              children: widget.comment.replies
                  .map((reply) => CommentCard(
                post: widget.post!,
                comment: reply,
                onReply: widget.onReply,
                isReply: true,
              ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
