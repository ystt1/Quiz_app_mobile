import 'package:quiz_app/domain/post/entity/comment_entity.dart';

import '../../user/model/simple_user_model.dart';

class CommentModel {
  final String id;
  final SimpleUserModel user;
  final String post;
  final String content;
  final String createdAt;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.user,
    required this.post,
    required this.content,
    required this.createdAt,
    required this.replies,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['_id']??"",
      user: SimpleUserModel.fromMap(map['user']),
      post: map['post']??"",
      content: map['content']??"",
      createdAt: map['createdAt']??"",
      replies: (map['replies'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user': user.toMap(),
      'post': post,
      'content': content,
      'createdAt': createdAt,
      'replies': replies.map((e) => e.toMap()).toList(),
    };
  }
}

extension CommentModelToEntity on CommentModel {
  CommentEntity toEntity() {
    return CommentEntity(
        id: id,
        user: user.toEntity(),
        post: post,
        content: content,
        createdAt: createdAt,
        replies: replies.map((e)=>e.toEntity()).toList());
  }
}
