import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/list_my_question.dart';
import 'package:quiz_app/common/widgets/question_card.dart';
import 'package:quiz_app/data/quiz/models/quiz_quetion_payload.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/remove_question_from_quiz_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_state.dart';
import 'package:quiz_app/presentation/library/widget/edit_quiz_model.dart';

class QuizDetailPage extends StatefulWidget {
  final BasicQuizEntity quiz;
  final VoidCallback? onRefresh;
  const QuizDetailPage({super.key, required this.quiz, this.onRefresh});

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  late bool isPrivate;
  List<int> selectedIndexes = [];
  bool isSelectionMode = false;
  @override
  void initState() {
    super.initState();
    isPrivate = widget.quiz.status == "active" ? true : false;
  }

  void onRefresh(BuildContext context)
  {
    context.read<GetQuizDetailCubit>().onGet(widget.quiz.id);
    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => ButtonStateCubit()),
        BlocProvider(
            create: (BuildContext context) =>
                GetQuizDetailCubit()..onGet(widget.quiz.id))
      ],
      child: BlocBuilder<GetQuizDetailCubit, GetQuizDetailState>(
        builder: (BuildContext context, GetQuizDetailState state) {
          if (state is GetQuizDetailLoading) {
            return const GetLoading();
          }
          if (state is GetQuizDetailFailure) {
            return GetFailure(name: state.error);
          }
          if (state is GetQuizDetailSuccess) {
            return BlocListener<ButtonStateCubit,ButtonState>(
              listener: (BuildContext context, state) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text("success"),)));
                  setState(() {
                    selectedIndexes.clear();
                    isSelectionMode=false;
                  });
                  onRefresh(context);

                }
              },
              child: Scaffold(
                appBar: !isSelectionMode? AppBar(
                  title: Text(state.quiz.name),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (innerContext) => EditQuizModal(onRefresh:()=> onRefresh(context), quiz: state.quiz),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit Quiz',
                    ),
                  ],
                ): AppBar(

                  actions: [
                    IconButton(onPressed: (){
                      setState(() {
                        selectedIndexes.clear();
                        isSelectionMode=false;
                      });
                    }, icon: Icon(Icons.cancel)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          final questionsToDelete = selectedIndexes
                              .map((index) => state.quiz.questions[index].id)
                              .toList();
                          context.read<ButtonStateCubit>().execute(
                            usecase: RemoveQuestionFromQuizUseCase(),
                            params: QuizQuestionPayload(
                              quizId: widget.quiz.id,
                              question: questionsToDelete,
                            ),
                          );
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _image(state.quiz.image),
                        const SizedBox(height: 16),
                       _description(state.quiz.description),
                        const SizedBox(height: 8),
                        _details(state.quiz.time.toString(), state.quiz.createdAt),
                        const SizedBox(
                          height: 16
                        ),
                        _topics(state.quiz.topicId),
                        const SizedBox(height: 16),
                        _privacy(),
                        const SizedBox(height: 16),
                        Text(
                          "Questions",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        _listQuestion(state.quiz.questions),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                builder: (innerContext) => ListMyQuestion(quiz: state.quiz,onRefresh:()=> onRefresh(context),),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add Question"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const GetSomethingWrong();
        },
      ),
    );
  }

  Widget _image(String image) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GestureDetector(
            onTap: () {
              // Action when tapping the image
            },
            child: Image.network(
              image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: () {
              // Edit image action
            },
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            color: Colors.black45,
            iconSize: 28,
            tooltip: 'Edit Image',
          ),
        ),
      ],
    );
  }

  Widget _description(String description)
  {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        description,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _details(String time, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Duration: $time mins",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade700),
          ),
          Text(
            "Created: $date",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _topics(List<TopicEntity> topics) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Topics",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topics
                .map((topic) => Chip(
                      label: Text(topic.name, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.grey.shade200,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _privacy()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Privacy",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              const Text("Private"),
              Switch(
                value: isPrivate,
                onChanged: (value) {
                  setState(() {
                    isPrivate = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listQuestion(List<BasicQuestionEntity> questions) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        final isSelected = selectedIndexes.contains(index);
        return GestureDetector(
          onLongPress: () {
            setState(() {
              isSelectionMode = true;
              selectedIndexes.add(index);
            });
          },
          onTap: () {
            if (isSelectionMode) {
              setState(() {
                if (isSelected) {
                  selectedIndexes.remove(index);
                } else {
                  selectedIndexes.add(index);
                }
                if (selectedIndexes.isEmpty) {
                  isSelectionMode = false;
                }
              });
            }
          },
          child: QuestionCard(
            question: question,
            index: index,
            isSelected: isSelected,
            isSelectedMode:isSelectionMode,
            onDelete: () {
              if (!isSelectionMode) {
                context.read<ButtonStateCubit>().execute(
                  usecase: RemoveQuestionFromQuizUseCase(),
                  params: QuizQuestionPayload(
                    quizId: widget.quiz.id,
                    question: [question.id],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
