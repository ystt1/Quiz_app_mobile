import 'package:quiz_app/domain/post/entity/post_entity.dart';

abstract class GetListPostState{}

class GetListPostLoading extends GetListPostState{}

class GetListPostSuccess extends GetListPostState{
  final List<PostEntity> posts;

  GetListPostSuccess({required this.posts});
}

class GetListPostFailure extends GetListPostState{
  final String error;

  GetListPostFailure({required this.error});
}
