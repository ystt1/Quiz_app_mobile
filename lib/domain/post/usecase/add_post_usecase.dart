import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/post/models/post_payload_model.dart';
import 'package:quiz_app/domain/post/repository/post_repository.dart';
import 'package:quiz_app/domain/team/repository/team_repository.dart';
import 'package:quiz_app/service_locator.dart';

class AddPostUseCase implements UseCase<Either,PostPayloadModel> {
  @override
  Future<Either> call({PostPayloadModel? params}) {
    return sl<PostRepository>().addPost(params!);
  }

}