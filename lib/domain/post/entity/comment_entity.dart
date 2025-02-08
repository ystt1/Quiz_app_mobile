
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class CommentEntity {
  final String id;
  final SimpleUserEntity user;
  final String post;
  final String content;
  final String createdAt;
  final List<CommentEntity> replies;

  CommentEntity({
    required this.id,
    required this.user,
    required this.post,
    required this.content,
    required this.createdAt,
    required this.replies,
  });
}
