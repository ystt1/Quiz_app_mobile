import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/data/question/models/edit_question_payload_model.dart';
import 'package:quiz_app/domain/question/entity/basic_answer_entity.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import '../../../data/question/models/basic_answer_model.dart';
import '../../../domain/question/usecase/edit_question_usecase.dart';


class EditQuestionModal extends StatefulWidget {
  final BasicQuestionEntity question;
  final VoidCallback onRefresh;

  const EditQuestionModal({super.key, required this.question, required this.onRefresh});

  @override
  State<EditQuestionModal> createState() => _EditQuestionModalState();
}

class _EditQuestionModalState extends State<EditQuestionModal> {
  late String selectedType;
  late double score;
  late String content;
  late List<String> answers;
  late int? selectedSingleChoiceIndex;
  late List<int> selectedMultiChoiceIndices;
  late String shortAnswerCorrect;

  bool isEdited = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    selectedType = widget.question.type;
    score = widget.question.score.toDouble();
    content = widget.question.content.replaceAll('___', '{}');
    answers = widget.question.answers.map((e) => e.content).toList();
    selectedSingleChoiceIndex = widget.question.answers.indexWhere((e) => e.isCorrect);
    selectedMultiChoiceIndices = widget.question.answers
        .asMap()
        .entries
        .where((entry) => entry.value.isCorrect)
        .map((entry) => entry.key)
        .toList();
    shortAnswerCorrect = widget.question.answers.isNotEmpty ? widget.question.answers.first.content : '';
  }

  void onSave(BuildContext context) {
    final updatedAnswers = answers.map((answer) {
      bool isCorrect = false;

      if (selectedType == 'selected-one') {
        isCorrect = answers.indexOf(answer) == selectedSingleChoiceIndex;
      } else if (selectedType == 'selected-many') {
        isCorrect = selectedMultiChoiceIndices.contains(answers.indexOf(answer));
      } else if (selectedType == 'fill-in-the-blank' || selectedType == 'drag-and-drop') {
        isCorrect = true;
      } else if (selectedType == 'constructed') {
        answer = shortAnswerCorrect;
        isCorrect = true;
      }

      return BasicAnswerModel(content: answer, isCorrect: isCorrect);
    }).toList();

    final updatedQuestion = EditQuestionPayloadModel(
      content: content.replaceAll('{}', '___'),
      score: score.toInt(),
      type: selectedType,
      answers: updatedAnswers, id: widget.question.id,
    );


    context.read<ButtonStateCubit>().execute(usecase: EditQuestionUseCase(), params: updatedQuestion);
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
        child: Builder(
          builder: (context) {
            return BlocListener<ButtonStateCubit, ButtonState>(
              listener: (BuildContext context, state) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                if (state is ButtonLoadingState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GetLoading()));
                }
                if (state is ButtonFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetFailure(name: state.errorMessage)));
                }
                if (state is ButtonSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Success"))));
                  widget.onRefresh();
                  Navigator.of(context).pop();
                }
              },
              child: SingleChildScrollView(
                child: isEditing ? _buildEditView(context) : _buildDetailView(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Question Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing=true;
                });
              },
            )
          ],
        ),
        const Divider(),
        _buildInfoRow(label: 'Question Type:', value: selectedType),
        _buildInfoRow(label: 'Score:', value: score.toString()),
        const SizedBox(height: 16),
        const Text(
          'Content:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        const Text(
          'Answers:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.question.answers.map((answer) => _buildAnswerRow(answer)),
      ],
    );
  }

  Widget _buildEditView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Edit Question',
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
                _buildSlider(
                  label: 'Score',
                  value: score,
                  onChanged: (value) {
                    setState(() {
                      score = value;
                      isEdited = true;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Question Content',
                  hint: 'Enter your question here...',
                  value: content,
                  onChanged: (value) {
                    setState(() {
                      content = value;
                      isEdited = true;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (selectedType == 'constructed')
                  _buildTextField(
                    label: 'Correct Answer',
                    hint: 'Enter the correct answer...',
                    value: shortAnswerCorrect,
                    onChanged: (value) {
                      setState(() {
                        shortAnswerCorrect = value;
                        isEdited = true;
                      });
                    },
                  ),
                if (selectedType == 'selected-one' || selectedType == 'selected-many')
                  _buildAnswersSection(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isEdited ? () => onSave(context) : null,
          child: const Text('Save'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: isEdited ? Colors.blueAccent : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildAnswerRow(BasicAnswerEntity answer) {
    return Card(
      color: answer.isCorrect ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Icon(
              answer.isCorrect ? Icons.check_circle : Icons.cancel,
              color: answer.isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                answer.content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
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
          min: 5,
          max: 100,
          divisions: 19,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: TextEditingController(text: value),
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
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: answer),
                    onChanged: (value) {
                      setState(() {
                        answers[index] = value;
                        isEdited = true;
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
                        isEdited = true;
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
                        isEdited = true;
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
                      isEdited = true;
                    });
                  },
                ),
              ],
            );
          }).toList(),
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              answers.add('');
              isEdited = true;
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
