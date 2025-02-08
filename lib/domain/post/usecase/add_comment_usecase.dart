import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/post/models/comment_payload_modal.dart';
import 'package:quiz_app/domain/post/repository/post_repository.dart';
import 'package:quiz_app/service_locator.dart';

class AddCommentUseCase implements UseCase<Either,CommentPayloadModal> {
  @override
  Future<Either> call({CommentPayloadModal? params}) async {
    return await sl<PostRepository>().addComment(params!);
  }

}