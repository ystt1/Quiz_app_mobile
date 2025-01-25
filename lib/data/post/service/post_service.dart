import 'package:dartz/dartz.dart';

abstract class PostService
{
  Future<Either> getPostService();
  Future<Either> addPostService();
  Future<Either> likePostService();
  Future<Either> getCommentService();
  Future<Either> addCommentService();
  Future<Either> likeCommentService();
  Future<Either> replyCommentService();
}

class PostServiceImp extends PostService{
  @override
  Future<Either> addCommentService() {
    // TODO: implement addCommentService
    throw UnimplementedError();
  }

  @override
  Future<Either> addPostService() {
    // TODO: implement addPostService
    throw UnimplementedError();
  }

  @override
  Future<Either> getCommentService() {
    // TODO: implement getCommentService
    throw UnimplementedError();
  }

  @override
  Future<Either> getPostService() {
    // TODO: implement getPostService
    throw UnimplementedError();
  }

  @override
  Future<Either> likeCommentService() {
    // TODO: implement likeCommentService
    throw UnimplementedError();
  }

  @override
  Future<Either> likePostService() {
    // TODO: implement likePostService
    throw UnimplementedError();
  }

  @override
  Future<Either> replyCommentService() {
    // TODO: implement replyCommentService
    throw UnimplementedError();
  }
}