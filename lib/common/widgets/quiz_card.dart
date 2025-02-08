import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state_2.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit_2.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/core/constant/app_color.dart';
import 'package:quiz_app/data/team/model/put_team_quiz_payload.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/delete_quiz_usecase.dart';
import 'package:quiz_app/domain/team/usecase/add_quiz_to_team_usecase.dart';
import 'package:quiz_app/domain/team/usecase/remove_quiz_from_team_usecase.dart';

import '../../presentation/team/bloc/get_team_detail_cubit.dart';
import '../bloc/button/button_state.dart';
import '../bloc/button/button_state_cubit.dart';

class QuizCard extends StatelessWidget {
  final VoidCallback onClick;
  final bool isYour;
  final BasicQuizEntity quiz;
  final bool isSelected;
  final bool isSelectedMode;
  final String type;
  final String idTeam;
  final bool isRemove;

  const QuizCard(
      {super.key,
      required this.onClick,
      required this.isYour,
      required this.quiz,
      this.isSelected = false,
      this.isSelectedMode = false,
      this.type = "null",
      this.idTeam = "",
      this.isRemove = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ButtonStateCubit2(),
      child: GestureDetector(
          onTap: onClick,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              _image(),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _nameAndMenu(context),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _information(Icons.timer, '${quiz.time} min'),
                          _information(
                              Icons.help, '${quiz.questionNumber} question'),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      _information(Icons.date_range, quiz.createdAt),
                      const SizedBox(
                        height: 3,
                      ),
                      _tag(),
                      const SizedBox(
                        height: 1.5,
                      ),
                      const Divider(height: 0.1),
                    ],
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  Widget _image() {
    return Container(
      width: 90,
      height: 105,
      decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 0.3)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Base64ImageWidget(base64String: quiz.image,)),
    );
  }

  Widget _nameAndMenu(BuildContext context) {
    return Row(
      children: [
        BlocListener<ButtonStateCubit2,ButtonState2>(

          listener: (BuildContext context, ButtonState2 state) {
            if(state is ButtonFailureState2)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetFailure(name: state.errorMessage)));
              }
            if(state is ButtonSuccessState2){
              if(type=='removeFromTeam') {
                context.read<GetTeamDetailCubit>().onRemoveQuiz(quiz);
              }
              if(type=='delete')
                {
                  context.read<GetListQuizCubit>().onRemoveQuiz([quiz]);
                }
            }
          },
          child: Expanded(
            child: Text(
              quiz.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ),
        ),
        isSelectedMode
            ? Checkbox(
                value: isSelected,
                onChanged: (value) {},
              )
            : type == 'null'
                ? const SizedBox()
                : Builder(
                  builder: (context) {
                    return (IconButton(
                        onPressed: () {
                          switch (type) {
                            case 'addToTeam':
                              context.read<ButtonStateCubit2>().execute(
                                  usecase: AddQuizToTeamUseCase(),
                                  params: PutTeamQuizPayload(
                                      idTeam: idTeam, quizIds: [quiz.id]));
                              break;
                            case 'removeFromTeam':
                              context
                                  .read<ButtonStateCubit2>()
                                  .execute(
                                      usecase: RemoveQuizFromTeamUseCase(),
                                      params: PutTeamQuizPayload(
                                          idTeam: idTeam, quizIds: [quiz.id]));
                              break;
                            case 'delete':
                              context.read<ButtonStateCubit2>().execute(usecase: DeleteQuizUseCase(),params: quiz.id);
                              break;
                            default:
                              print("wrong type");
                              break;
                          }
                        },
                        icon: type == 'addToTeam'
                            ? const Icon(Icons.add_circle_outline, color: Colors.green)
                            : const Icon(Icons.delete, color: Colors.red),
                      ));
                  }
                ),
      ],
    );
  }

  Widget _tag() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: quiz.topicId
            .map(
              (topic) => Container(
                child: Row(
                  children: [
                    const Icon(Icons.tag, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      topic.name,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _information(IconData icon, String property) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          property,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
