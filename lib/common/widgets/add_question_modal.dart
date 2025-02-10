import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/data/question/models/question_payload_model.dart';
import 'package:quiz_app/domain/question/usecase/add_question_usecase.dart';

import '../../data/question/models/basic_answer_model.dart';

class AddQuestionModal extends StatefulWidget {
  final VoidCallback onRefresh;

  const AddQuestionModal({super.key, required this.onRefresh});

  @override
  State<AddQuestionModal> createState() => _ModalContentState();
}

class _ModalContentState extends State<AddQuestionModal> {
  String selectedType = 'constructed';
  double score = 10;

  final List<String> questionTypes = [
    'constructed',
    'selected-one',
    'selected-many',
    'fill-in-the-blank',
    'drag-and-drop'
  ];

  List<String> answers = [''];
  int? selectedSingleChoiceIndex;
  List<int> selectedMultiChoiceIndices = [];
  String shortAnswerCorrect = '';
  String content = '';

  void onSave(BuildContext context) {
    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question content cannot be empty!')),
      );
      return;
    }

    final Set<String> uniqueAnswers = {};
    bool hasDuplicate = false;
    for (String answer in answers) {
      if (!uniqueAnswers.add(answer.trim())) {
        hasDuplicate = true;
        break;
      }
    }

    if (hasDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answers cannot be duplicated!')),
      );
      return;
    }

    if (selectedType == 'selected-one' && (selectedSingleChoiceIndex == null || selectedSingleChoiceIndex! >= answers.length)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Single-choice questions must have at least one correct answer!')),
      );
      return;
    }

    if (selectedType == 'selected-many' && selectedMultiChoiceIndices.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Multiple-choice questions must have at least two correct answers!')),
      );
      return;
    }

    if (selectedType == 'fill-in-the-blank' ||
        selectedType == 'drag-and-drop') {
      final regex = RegExp(r'\{(.*?)\}');
      final matches = regex.allMatches(content);

      if (matches.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Fill-in-the-blank questions must have at least one blank!')),
        );
        return;
      }

      answers = matches.map((match) => match.group(1)?.trim() ?? '').toList();

      if (answers.any((answer) => answer.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Fill-in-the-blank answers cannot be empty!')),
        );
        return;
      }

      content = content.replaceAll(regex, '___');
    }

    if (selectedType != 'constructed' &&
        answers.any((answer) => answer.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answers cannot be empty!')),
      );
      return;
    }

    if (selectedType == 'constructed' && shortAnswerCorrect.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Correct answer cannot be empty for constructed questions!')),
      );
      return;
    }

    final List<BasicAnswerModel> answerModels = answers.map((answer) {
      bool isCorrect = false;

      if (selectedType == 'selected-one') {
        isCorrect = answers.indexOf(answer) == selectedSingleChoiceIndex;
      } else if (selectedType == 'selected-many') {
        isCorrect =
            selectedMultiChoiceIndices.contains(answers.indexOf(answer));
      } else if (selectedType == 'fill-in-the-blank' ||
          selectedType == 'drag-and-drop') {
        isCorrect = true;
      } else if (selectedType == 'constructed') {
        answer = shortAnswerCorrect;
        isCorrect = true;
      }

      return BasicAnswerModel(content: answer, isCorrect: isCorrect);
    }).toList();

    final question = QuestionPayload(
      content: content,
      score: score.toInt(),
      type: selectedType,
      answers: answerModels,
    );


    context
        .read<ButtonStateCubit>()
        .execute(usecase: AddQuestionUseCase(), params: question);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ButtonStateCubit>(
      create: (BuildContext context) => ButtonStateCubit(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Builder(builder: (context) {
          return BlocListener<ButtonStateCubit, ButtonState>(
            listener: (BuildContext context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (state is ButtonLoadingState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: GetLoading()));
              }
              if (state is ButtonFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: GetFailure(name: state.errorMessage)));
              }
              if (state is ButtonSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Center(
                  child: Text("success"),
                )));
                widget.onRefresh();
                Navigator.of(context).pop();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Create a New Question',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDropdown(
                            label: 'Type of Question',
                            value: selectedType,
                            items: questionTypes,
                            onChanged: (value) {
                              setState(() {
                                String previousType = selectedType;
                                selectedType = value!;

                                selectedSingleChoiceIndex = null;
                                selectedMultiChoiceIndices.clear();
                                shortAnswerCorrect = '';

                                if (previousType != 'selected-many' &&
                                    selectedType == 'selected-many') {
                                  if (answers.isEmpty) {
                                    answers = [''];
                                  }
                                } else if (selectedType != 'selected-many' &&
                                    selectedType != 'selected-one') {
                                  answers = [''];
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildSlider(
                            label: 'Score',
                            value: score,
                            onChanged: (value) {
                              setState(() {
                                score = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Question Content',
                            hint: 'Enter your question here...',
                            onChanged: (value) {
                              setState(() {
                                content = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          if (selectedType == 'constructed')
                            _buildTextField(
                              label: 'Correct Answer',
                              hint: 'Enter the correct answer...',
                              onChanged: (value) {
                                setState(() {
                                  shortAnswerCorrect = value;
                                });
                              },
                            ),
                          if (selectedType == 'selected-one' ||
                              selectedType == 'selected-many')
                            _buildAnswersSection(),
                          if (selectedType == 'fill-in-the-blank' ||
                              selectedType == 'drag-and-drop')
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Use {answer} to specify blanks. Example: The capital of France is {Paris}.',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Builder(builder: (context) {
                    return ElevatedButton(
                      onPressed: () => onSave(context),
                      child: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: 10,
          max: 100,
          divisions: 18,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Answers'),
        Column(
          children: answers.asMap().entries.map((entry) {
            int index = entry.key;
            String answer = entry.value;
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          answers[index] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Answer ${index + 1}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  if (selectedType == 'selected-one')
                    Radio<int>(
                      value: index,
                      groupValue: selectedSingleChoiceIndex,
                      onChanged: (int? value) {
                        setState(() {
                          selectedSingleChoiceIndex = value;
                        });
                      },
                    ),
                  if (selectedType == 'selected-many')
                    Checkbox(
                      value: selectedMultiChoiceIndices.contains(index),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedMultiChoiceIndices.add(index);
                          } else {
                            selectedMultiChoiceIndices.remove(index);
                          }
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        answers.removeAt(index);
                        if (selectedSingleChoiceIndex == index) {
                          selectedSingleChoiceIndex = null;
                        }
                        selectedMultiChoiceIndices.remove(index);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              answers.add('');
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Answer'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
