import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/topic/select_topic_cubit.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/data/quiz/models/quiz_payload_model.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/add_quiz_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_state.dart';

import '../helper/get_img_string.dart';

class AddQuizModal extends StatefulWidget {
  final VoidCallback onRefresh;
  const AddQuizModal({Key? key, required this.onRefresh}) : super(key: key);

  @override
  State<AddQuizModal> createState() => _AddQuizModalState();
}

class _AddQuizModalState extends State<AddQuizModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String quizImageUrl = '';

  void _saveQuiz(BuildContext context,List<TopicEntity> topics) {
    String quizName = _nameController.text;
    String quizDescription = _descriptionController.text;
    String quizTime = _timeController.text;

    if (quizName.isEmpty ||
        quizDescription.isEmpty ||
        quizImageUrl.isEmpty ||
        quizTime.isEmpty ||
        topics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill all fields and select at least one topic')),
      );
      return;
    }
    context.read<ButtonStateCubit>().execute(
        usecase: AddQuizUseCase(),
        params: QuizPayloadModel(
            name: _nameController.text,
            description: _descriptionController.text,
            topicId: topics.map((TopicEntity e) => e.toModel()).toList(),
            image: quizImageUrl,
            time: int.parse(_timeController.text)));
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
            create: (BuildContext context) => SelectTopicCubit([]),
          )
        ],
        child: BlocListener<ButtonStateCubit,ButtonState>(
          listener: (BuildContext context, state) { 
            if(state is ButtonLoadingState)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetLoading()));
              }
            if(state is ButtonFailureState)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetFailure(name: state.errorMessage)));
            }
            if(state is ButtonSuccessState)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetFailure(name: "success")));
              widget.onRefresh();
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<SelectTopicCubit,List<TopicEntity>>(
            builder: (BuildContext context, List<TopicEntity> topics) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                // Ensure modal height adapts to content
                children: [
                  const Center(
                    child: Text(
                      'Add a New Quiz',
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
                  const Text('Quiz Image URL'),
                  Row(
                    children: [
                      IconButton(onPressed: () async {
                        String? imageString = await getImgString();
                        if(imageString!=null) {
                          setState(() {
                            quizImageUrl = imageString!;
                          });
                        }

                      }, icon: Icon(Icons.image)),
                      Container(
                        height: 50,
                        width: 50,
                        child: quizImageUrl!=""? Base64ImageWidget(base64String: quizImageUrl,):SizedBox(),
                      ),
                      
                    ],
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
                              selected: topics.contains(topic),
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
                  const Text('Time (in second)'),
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
                          onPressed: () => _saveQuiz(context,topics),
                          child: const Text('Save Quiz'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
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
