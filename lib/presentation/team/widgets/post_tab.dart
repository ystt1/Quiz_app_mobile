import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/post_card.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';
import 'package:quiz_app/presentation/team/bloc/get_list_post_cubit.dart';
import 'package:quiz_app/presentation/team/bloc/get_list_post_state.dart';


class PostTab extends StatelessWidget {
  final TeamEntity team;
  const PostTab({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return
       BlocBuilder<GetListPostCubit,GetListPostState>(
        builder: (BuildContext context, state) {
          if(state is GetListPostLoading)
            {
              return GetLoading();
            }
          if(state is GetListPostFailure)
          {
            return GetFailure(name: state.error);
          }
          if(state is GetListPostSuccess)
          {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: state.posts[index],);
              },
            );
          }
          return GetSomethingWrong();
        },


    );
  }
}
