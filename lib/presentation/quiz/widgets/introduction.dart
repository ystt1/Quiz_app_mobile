import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';

import '../../../common/bloc/quiz/get_list_quiz_cubit.dart';
import '../../../common/bloc/quiz/get_list_quiz_state.dart';
import '../../../common/widgets/build_base_64_image.dart';
import '../../../common/widgets/get_failure.dart';
import '../../../common/widgets/get_loading.dart';
import '../../../common/widgets/get_something_wrong.dart';
import '../pages/practice_quiz_detail_page.dart';

class Introduction extends StatelessWidget {
  final BasicQuizEntity quiz;
  const Introduction({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          const Text(
            'Description:',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          Text(quiz.description),
          const SizedBox(height: 8.0),
          const Text(
            'Topics:',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          Wrap(
            children: [
              ...quiz.topicId
                  .map((e) => Chip(label: Text(e.name)))
                  .toList(),
            ],
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Other Quizzes by Owner:',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10,),
          BlocBuilder<GetListQuizCubit, GetListQuizState>(
            builder: (BuildContext context,
                GetListQuizState state) {
              if (state is GetListQuizLoading) {
                return const GetLoading();
              }
              if (state is GetListQuizFailure) {
                return GetFailure(name: state.error);
              }
              if (state is GetListQuizSuccess) {
                return SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    PracticeQuizDetailPage(
                                      quizId: state
                                          .quizzes[index]
                                          .id,
                                    )),
                          );
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.only(
                              right: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                            BorderRadius.circular(
                                8.0),
                          ),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(
                                8.0),
                            child: Base64ImageWidget(
                              base64String: state
                                  .quizzes[index].image,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: state.quizzes.length,
                  ),
                );
              }
              return GetSomethingWrong();
            },
          ),
        ],
      ),
    );
  }
}
