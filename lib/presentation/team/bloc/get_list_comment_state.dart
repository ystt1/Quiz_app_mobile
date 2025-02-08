

import 'package:quiz_app/domain/post/entity/comment_entity.dart';

abstract class GetListCommentState{}

class GetListCommentLoading extends GetListCommentState{}

class GetListCommentSuccess extends GetListCommentState{
  final List<CommentEntity> comments;

  GetListCommentSuccess({required this.comments});
}

class GetListCommentFailure extends GetListCommentState{
  final String error;

  GetListCommentFailure({required this.error});
}
