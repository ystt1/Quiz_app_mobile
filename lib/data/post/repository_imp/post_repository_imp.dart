import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/post/service/post_service.dart';

import '../../../domain/post/repository/post_repository.dart';
import '../../../service_locator.dart';

class PostRepositoryImp extends PostRepository{
  @override
  Future<Either> addComment() async {
    return await sl<PostService>().addCommentService();
  }

  @override
  Future<Either> addPost() async {
    return await sl<PostService>().addPostService();
  }

  @override
  Future<Either> getComment() async {
    return await sl<PostService>().getCommentService();
  }

  @override
  Future<Either> getPost() async {
    return await sl<PostService>().getPostService();
  }

  @override
  Future<Either> likeComment() async {
    return await sl<PostService>().likeCommentService();
  }

  @override
  Future<Either> likePost() async {
    return await sl<PostService>().likePostService();
  }

  @override
  Future<Either> replyComment() async {
    return await sl<PostService>().replyCommentService();
  }
}