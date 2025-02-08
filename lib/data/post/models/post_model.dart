import 'package:quiz_app/data/user/model/simple_user_model.dart';
import 'package:quiz_app/domain/post/entity/post_entity.dart';

class PostModel{
  final String id;
  final String content;
  final SimpleUserModel creator;
  final String image;
  final String quiz;
  final String createdAt;
  final int likeCount;
  final int commentCount;
  final bool statusLike;

  PostModel( {required this.id, required this.content, required this.creator, required this.createdAt, required this.likeCount, required this.commentCount,required this.image,required this.quiz,required this.statusLike});


  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['_id'] ??"",
      content: map['content']??"",
      creator:SimpleUserModel.fromMap(map['creator']),
      createdAt: map['createdAt'] ??"",
      likeCount: map['likeCount'] ??0,
      commentCount: map['commentCount'] ??0,
      image: map['image'] ??"",
      quiz: map['quiz'] ??"",
      statusLike: map['statusLike'] ??false,
    );
  }
}

extension PostModelToEntity on PostModel{
  PostEntity toEntity()
  {
    return PostEntity(id: id, content: content, creator: creator.toEntity(), createdAt: createdAt, likeCount: likeCount, commentCount: commentCount, image: image, quiz: quiz,statusLike: statusLike);
  }
}