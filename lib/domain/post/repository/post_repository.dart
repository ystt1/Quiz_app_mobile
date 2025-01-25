import 'package:dartz/dartz.dart';

abstract class PostRepository
{
  Future<Either> getPost();
  Future<Either> addPost();
  Future<Either> likePost();
  Future<Either> getComment();
  Future<Either> addComment();
  Future<Either> likeComment();
  Future<Either> replyComment();
}