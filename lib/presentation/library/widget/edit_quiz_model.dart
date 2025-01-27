import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/topic/select_topic_cubit.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/data/quiz/models/edit_quiz_model.dart';
import 'package:quiz_app/data/quiz/models/quiz_model.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/edit_quiz_detail_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_state.dart';

class EditQuizModal extends StatefulWidget {
  final VoidCallback onRefresh;
  final BasicQuizEntity quiz;

  const EditQuizModal({Key? key, required this.onRefresh, required this.quiz})
      : super(key: key);

  @override
  State<EditQuizModal> createState() => _EditQuizModalState();
}

class _EditQuizModalState extends State<EditQuizModal> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeController;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.quiz.name);
    _descriptionController =
        TextEditingController(text: widget.quiz.description);
    _timeController = TextEditingController(text: widget.quiz.time.toString());
  }

  void _updateQuiz(BuildContext context,List<TopicEntity> topics) {
    String quizName = _nameController.text;
    String quizDescription = _descriptionController.text;
    String quizTime = _timeController.text;

    if (quizName.isEmpty ||
        quizDescription.isEmpty ||
        quizTime.isEmpty ||
        topics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select at least one topic'),
        ),
      );
      return;
    }

    context.read<ButtonStateCubit>().execute(
          usecase: EditQuizDetailUseCase(),
          params: EditQuizModel(
              id: widget.quiz.id,
              name: quizName,
              description: quizDescription,
              topicId: topics.map((e)=>e.toModel()).toList(),
              questions: widget.quiz.questions.map((e)=>e.toModel()).toList(),
              image: widget.quiz.image,
              idCreator: widget.quiz.idCreator,
              status: widget.quiz.status,
              time: int.parse(quizTime),
             ),
        );
  }

  void _toggleTopic(BuildContext context,TopicEntity topic,List<TopicEntity> topics) {
    context.read<SelectTopicCubit>().onSelect(topic);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => GetAllTopicCubit()..onGet(),
          ),
          BlocProvider(
            create: (BuildContext context) => ButtonStateCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => SelectTopicCubit(widget.quiz.topicId),
          ),
        ],
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (BuildContext context, state) {
            if (state is ButtonLoadingState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: GetLoading()));
            }
            if (state is ButtonFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: GetFailure(name: state.errorMessage)));
            }
            if (state is ButtonSuccessState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: GetFailure(name: "success")));
              widget.onRefresh();
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<SelectTopicCubit,List<TopicEntity>>(
            builder: (BuildContext context, List<TopicEntity> topics) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Edit Quiz',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Quiz Name'),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter quiz name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Description'),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter quiz description...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Topics'),
                  BlocBuilder<GetAllTopicCubit, GetAllTopicState>(
                    builder: (BuildContext context, GetAllTopicState state) {
                      if (state is GetAllTopicLoading) {
                        return GetLoading();
                      }
                      if (state is GetAllTopicFailure) {
                        return GetFailure(name: state.error);
                      }
                      if (state is GetAllTopicSuccess) {
                            return Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: state.topics.map((topic) {
                                return FilterChip(
                                  label: Text(topic.name),
                                  selected: topics.any((e) => e.id == topic.id),
                                  onSelected: (isSelected) {
                                    _toggleTopic(context,topic,topics);
                                  },
                                  selectedColor: Colors.blueAccent.withOpacity(0.2),
                                  backgroundColor: Colors.grey.shade200,
                                );
                              }).toList(),
                            );
                      }
                      return GetSomethingWrong();
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Time (in minutes)'),
                  TextField(
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter quiz time...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () => _updateQuiz(context,topics),
                        child: const Text('Update Quiz'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
