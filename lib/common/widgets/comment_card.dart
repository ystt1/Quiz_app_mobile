import 'package:flutter/material.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/common/widgets/build_avatar.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/click_user_detail.dart';
import 'package:quiz_app/common/widgets/text_expandable.dart';
import 'package:quiz_app/domain/post/entity/comment_entity.dart';
import 'package:quiz_app/domain/post/entity/post_entity.dart';

class CommentCard extends StatefulWidget {
  final String? idTeam;
  final PostEntity? post;
  final CommentEntity comment;
  final Function(CommentEntity) onReply;
  final bool? isReply;
  final String? idQuiz;

  const CommentCard({
    super.key,
    this.idTeam,
    this.idQuiz,
    this.post,
    required this.comment,
    required this.onReply,
    this.isReply = false,
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
        // Comment chính
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isReply! ? Colors.grey[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(
                onTap:()=> onClickUser(context, widget.comment.user.id, widget.idTeam),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Base64ImageWidget(base64String:  widget.comment.user.avatar),
                      ),
                    ),

                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.comment.user.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Nội dung comment
              ExpandableText(text: widget.comment.content),

              const SizedBox(height: 6),

              // Reply & Thời gian
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget.isReply!)
                    TextButton(
                      onPressed: () => widget.onReply(widget.comment),
                      child: const Text(
                        "Reply",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
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
            ],
          ),
        ),

        // Nút xem phản hồi
        if (widget.comment.replies.isNotEmpty && !widget.isReply!)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 2.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  showReplies = !showReplies;
                });
              },
              child: Text(
                showReplies
                    ? "Hide replies"
                    : "View ${widget.comment.replies.length} replies",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Danh sách phản hồi
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
