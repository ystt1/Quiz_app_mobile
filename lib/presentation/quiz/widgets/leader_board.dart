import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/presentation/quiz/bloc/get_leader_board_cubit.dart';
import 'package:quiz_app/presentation/quiz/bloc/get_leader_board_state.dart';

import '../../../domain/quiz/entity/user_score_entity.dart';

class LeaderBoard extends StatelessWidget {
  final BasicQuizEntity quiz;

  const LeaderBoard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => GetLeaderBoardCubit()..onGet(quiz.id),
        child: BlocBuilder<GetLeaderBoardCubit, GetLeaderBoardState>(
          builder: (BuildContext context, GetLeaderBoardState state) {
            if (state is GetLeaderBoardLoading) {
              return const GetLoading();
            }
            if (state is GetLeaderBoardFailure) {
              return GetFailure(name: state.error);
            }
            if (state is GetLeaderBoardSuccess) {
              return Column(
                children: [
                  _buildTopThree(state.leaderBoard.boardData),
                  state.leaderBoard.boardData.length > 3
                      ? Expanded(
                          child: _buildLeaderBoard(state.leaderBoard.boardData))
                      : const SizedBox.shrink(),
                  _buildMyRanking(state.leaderBoard.myData),
                ],
              );
            }
            return const GetSomethingWrong();
          },
        ));
  }

  Widget _buildTopThree(List<UserScoreEntity> boardData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        if (index >= boardData.length) return const SizedBox();
        final userScore = boardData[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: index == 1 ? 40 : 35,
                backgroundColor: Colors.amberAccent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Base64ImageWidget(
                    base64String: userScore.user.avatar,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "#${userScore.rank} ${userScore.user.email}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: index == 0
                      ? Colors.amber
                      : index == 1
                          ? Colors.grey
                          : Colors.brown,
                ),
              ),
              Text("Score: ${userScore.score}"),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLeaderBoard(List<UserScoreEntity> boardData) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: boardData.length - 3,
      itemBuilder: (context, index) {
        final userScore = boardData[index + 3];
        return Card(
          elevation: 6.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: ListTile(
            leading: CircleAvatar(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Base64ImageWidget(
                base64String: userScore.user.avatar,
              ),
            )),
            title: Text(
              "#${userScore.rank} ${userScore.user.email}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                "Score: ${userScore.score} | Time: ${userScore.completeTime}s"),
            trailing: const Icon(Icons.emoji_events, color: Colors.blueAccent),
          ),
        );
      },
    );
  }

  Widget _buildMyRanking(UserScoreEntity myData) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: myData.user.id == ''
          ? const Center(
              child: Text("you not enter leaderboard yet"),
            )
          : ListTile(
              leading: CircleAvatar(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Base64ImageWidget(
                      base64String: myData.user.avatar,
                    )),
              ),
              title: Text(
                "Your Rank: #${myData.rank}",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  "Score: ${myData.score} | Time: ${myData.completeTime}s",
                  style: const TextStyle(color: Colors.white70)),
            ),
    );
  }
}
