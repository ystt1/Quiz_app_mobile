import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/post/models/comment_model.dart';
import 'package:quiz_app/data/post/models/comment_payload_modal.dart';
import 'package:quiz_app/data/post/models/post_model.dart';
import 'package:quiz_app/data/post/service/post_service.dart';

import '../../../domain/post/repository/post_repository.dart';
import '../../../service_locator.dart';
import '../models/post_payload_model.dart';

class PostRepositoryImp extends PostRepository{
  @override
  Future<Either> addComment(CommentPayloadModal comment) async {
    return await sl<PostService>().addCommentService(comment);
  }

  @override
  Future<Either> addPost(PostPayloadModel post) async {
    return await sl<PostService>().addPostService(post);

  }

  @override
  Future<Either> getComment(CommentPayloadModal comment) async {
    try {
      final returnedData = await sl<PostService>().getCommentService(comment);
      return returnedData.fold((error) => Left(error), (data) {
        return Right((data as List<CommentModel>)
            .map((CommentModel e) => e.toEntity())
            .toList());
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getPost(String teamId) async {
    try {
      final returnedData = await sl<PostService>().getPostService(teamId);
      return returnedData.fold((error) => Left(error), (data) {
        return Right((data as List<PostModel>)
            .map((PostModel e) => e.toEntity())
            .toList());
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> likeComment() async {
    return await sl<PostService>().likeCommentService();
  }

  @override
  Future<Either> likePost(String idPost) async {
    return await sl<PostService>().likePostService(idPost);
  }

  @override
  Future<Either> replyComment() async {
    return await sl<PostService>().replyCommentService();
  }
}