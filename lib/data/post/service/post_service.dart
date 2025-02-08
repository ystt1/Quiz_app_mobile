import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/constant/url.dart';
import 'package:quiz_app/data/api_service.dart';
import 'package:quiz_app/data/post/models/comment_model.dart';
import 'package:quiz_app/data/post/models/comment_payload_modal.dart';
import 'package:quiz_app/data/post/models/post_model.dart';
import 'package:quiz_app/data/post/models/post_payload_model.dart';
import 'package:quiz_app/service_locator.dart';
import 'package:http/http.dart' as http;

import '../../team/model/join_request_model.dart';
abstract class PostService
{
  Future<Either> getPostService(String teamId);
  Future<Either> likePostService(String idPost);
  Future<Either> getCommentService(CommentPayloadModal comment);
  Future<Either> addCommentService(CommentPayloadModal comment);
  Future<Either> likeCommentService();
  Future<Either> replyCommentService();
  Future<Either> addPostService(PostPayloadModel post);
}

class PostServiceImp extends PostService{
  @override
  Future<Either> addCommentService(CommentPayloadModal comment) async {
    try {
      print(comment.toMap());
      final apiService = sl<ApiService>();
      final response = await apiService
          .post('http://$url:5000/api/comment', comment.toMap());
      if  (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addPostService(PostPayloadModel post) async {
   try {
      final apiService = sl<ApiService>();
      final response = await apiService
          .post('http://$url:5000/api/post', post.toMap());
      if  (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getPostService(String teamId) async {
    try {

      final apiService = sl<ApiService>();
      final response = await apiService
          .get('http://$url:5000/api/post?teamId=$teamId');

      if (response.statusCode == 200) {
        
        final data =
        (jsonDecode(response.body)["data"] as List<dynamic>)
            .map((e) => PostModel.fromMap(e))
            .toList();
        return Right(data);
      }
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "api went wrong");
    } catch (e) {

      return Left(e.toString());
    }
  }

  @override
  Future<Either> getCommentService(CommentPayloadModal comment) async {
    try {

      final response = await http.get(
          Uri.parse('http://$url:5000/api/comment?${comment.post!=""?"idPost=${comment.post}":"idQuiz=${comment.idQuiz}"}'));

      if (response.statusCode == 200) {
        final data =
        (jsonDecode(response.body)["data"] as List<dynamic>)
            .map((e) => CommentModel.fromMap(e))
            .toList();
        return Right(data);
      }
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "api went wrong");
    } catch (e) {

      return Left(e.toString());
    }
  }


  @override
  Future<Either> likeCommentService() {
    // TODO: implement likeCommentService
    throw UnimplementedError();
  }

  @override
  Future<Either> likePostService(String idPost) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService
          .post('http://$url:5000/api/post/$idPost/like', {});
      if  (response.statusCode == 200) {
        return Right((jsonDecode(response.body)));
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Api went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> replyCommentService() {
    // TODO: implement replyCommentService
    throw UnimplementedError();
  }
}