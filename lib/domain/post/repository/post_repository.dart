import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/post/models/post_payload_model.dart';

import '../../../data/post/models/comment_payload_modal.dart';

abstract class PostRepository
{
  Future<Either> getPost(String teamId);
  Future<Either> addPost(PostPayloadModel post);
  Future<Either> likePost(String idPost);
  Future<Either> getComment(CommentPayloadModal comment);
  Future<Either> addComment(CommentPayloadModal comment);
  Future<Either> likeComment();
  Future<Either> replyComment();
}