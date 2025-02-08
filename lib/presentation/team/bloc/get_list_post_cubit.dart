import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/post/entity/post_entity.dart';
import 'package:quiz_app/domain/post/usecase/get_list_post_use_case.dart';

import 'package:quiz_app/presentation/team/bloc/get_list_post_state.dart';

import '../../../service_locator.dart';

class GetListPostCubit extends Cubit<GetListPostState> {
  GetListPostCubit() : super(GetListPostLoading());

  onGet(String teamId) async {
    emit(GetListPostLoading());
    try {
      final returnedData = await sl<GetListPostUseCase>().call(params: teamId);
      returnedData.fold((error) => emit(GetListPostFailure(error: error)),
          (data) => emit(GetListPostSuccess(posts: data)));
    } catch (e) {
      emit(GetListPostFailure(error: e.toString()));
    }
  }

  void likePost(String postId) {
    if (state is GetListPostSuccess) {
      final currentState = state as GetListPostSuccess;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == postId) {
          return PostEntity(
              id: post.id,
              content: post.content,
              creator: post.creator,
              createdAt: post.createdAt,
              likeCount: post.statusLike == true
                  ? post.likeCount - 1
                  : post.likeCount + 1,
              commentCount: post.commentCount,
              image: post.image,
              quiz: post.quiz,
              statusLike: !post.statusLike);
        }
        return post;
      }).toList();

      emit(GetListPostSuccess(posts: updatedPosts));
    }
  }

  void updatePost(PostEntity newPost) {
    if (state is GetListPostSuccess) {
      final currentState = state as GetListPostSuccess;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == newPost.id) {
          return PostEntity(
              id: newPost.id,
              content: newPost.content,
              creator: newPost.creator,
              createdAt: newPost.createdAt,
              likeCount: newPost.likeCount,
              commentCount: newPost.commentCount,
              image: newPost.image,
              quiz: newPost.quiz,
              statusLike: newPost.statusLike);
        }
        return post;
      }).toList();

      emit(GetListPostSuccess(posts: updatedPosts));
    }
  }
}
