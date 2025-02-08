import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/post/repository/post_repository.dart';

import 'package:quiz_app/service_locator.dart';

class GetListPostUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String? params}) async {
    print(params);
    return await sl<PostRepository>().getPost(params!);
  }

}