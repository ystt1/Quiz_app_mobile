import 'package:quiz_app/domain/quiz/entity/simple_quiz_entity.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class PostEntity {
  final String id;
  final String content;
  final SimpleUserEntity creator;
  final String image;
  final SimpleQuizEntity quiz;
  final String createdAt;
  final int likeCount;
  final int commentCount;
  final bool statusLike;
  PostEntity(
      {required this.id,
      required this.content,
      required this.creator,
      required this.createdAt,
      required this.likeCount,
      required this.commentCount,
      required this.image,
      required this.quiz,
      required this.statusLike});
}
