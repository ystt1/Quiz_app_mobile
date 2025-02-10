  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:quiz_app/common/bloc/button/button_state.dart';
  import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
  import 'package:quiz_app/common/widgets/get_failure.dart';
  import 'package:quiz_app/common/widgets/get_loading.dart';
  import 'package:quiz_app/data/question/models/edit_question_payload_model.dart';
  import 'package:quiz_app/domain/question/entity/basic_answer_entity.dart';
  import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
  import 'package:quiz_app/presentation/library/bloc/get_my_question_cubit.dart';
  import '../../../data/question/models/basic_answer_model.dart';
  import '../../../domain/question/usecase/edit_question_usecase.dart';


  class EditQuestionModal extends StatefulWidget {
    final BasicQuestionEntity question;
    final VoidCallback onRefresh;
    final BuildContext parenContext;
    const EditQuestionModal({super.key, required this.question, required this.onRefresh, required this.parenContext});

    @override
    State<EditQuestionModal> createState() => _EditQuestionModalState();
  }

  class _EditQuestionModalState extends State<EditQuestionModal> {
    late TextEditingController contentController;
    late String selectedType;
    late double score;
    late String content;
    late List<String> answers;
    late int? selectedSingleChoiceIndex;
    late List<int> selectedMultiChoiceIndices;
    late String shortAnswerCorrect;
    EditQuestionPayloadModel? editQuestionPayloadModel;
    bool isEdited = false;
    bool isEditing = false;

    late List<TextEditingController> answerControllers;
    late TextEditingController shortAnswerController;
    @override
    void initState() {
      super.initState();


      content = widget.question.content.isNotEmpty ? widget.question.content:"";

      answers = widget.question.answers.map((e) => e.content).toList();
      selectedType = widget.question.type;
      score = widget.question.score.toDouble();
      contentController = TextEditingController(text: content);
      selectedSingleChoiceIndex = widget.question.answers.indexWhere((e) => e.isCorrect);
      selectedMultiChoiceIndices = widget.question.answers
          .asMap()
          .entries
          .where((entry) => entry.value.isCorrect)
          .map((entry) => entry.key)
          .toList();

      shortAnswerCorrect = widget.question.answers.isNotEmpty ? widget.question.answers.first.content : '';
      shortAnswerController = TextEditingController(text: widget.question.answers.isNotEmpty
          ? widget.question.answers.first.content
          : '');
      answerControllers = widget.question.answers
          .map((e) => TextEditingController(text: e.content))
          .toList();
    }

    bool hasDuplicateAnswers() {
      Set<String> uniqueAnswers = {};
      for (var controller in answerControllers) {
        String answer = controller.text.trim();
        if (answer.isNotEmpty && uniqueAnswers.contains(answer)) {
          return true;
        }
        uniqueAnswers.add(answer);
      }
      return false;
    }


    void enterEditMode() {
      if (selectedType == 'drag-and-drop' ||
          selectedType == 'fill-in-the-blank') {
        String updatedContent = content;
        for (int i = 0; i < answers.length; i++) {
          updatedContent = updatedContent.replaceFirst('___', '{${answers[i]}}');
        }

        contentController = TextEditingController(text: updatedContent);
        setState(() {
          isEditing = true;
          content = updatedContent;
        });
      } else {
        setState(() {
          isEditing = true;
        });
      }
    }



    void onSave(BuildContext context) {

      if (contentController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Question content cannot be empty")),
        );
        return;
      }
      if ((selectedType == 'selected-many'|| selectedType == 'selected-one') && hasDuplicateAnswers()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Answers must be unique")),
        );
        return;
      }

      List<String> extractedAnswers = [];
      String updatedContent = contentController.text;

      if (selectedType == 'drag-and-drop' || selectedType == 'fill-in-the-blank') {
        final regex = RegExp(r'\{(.*?)\}');
        final matches = regex.allMatches(contentController.text);

        extractedAnswers = matches.map((match) => match.group(1) ?? "").toList();

        if (extractedAnswers.any((answer) => answer.trim().isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Each {} must contain a valid answer")),
          );
          return;
        }

        updatedContent = contentController.text.replaceAll(regex, '___');
      }


      if ((selectedType == 'drag-and-drop' || selectedType == 'fill-in-the-blank') && extractedAnswers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fill-in-the-blank and drag-and-drop must have answers inside {}")),
        );
        return;
      }


      if (answerControllers.any((controller) => controller.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Answers cannot be empty")),
        );
        return;
      }


      if (selectedType == 'selected-one' && selectedSingleChoiceIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one correct answer for 'selected-one' type")),
        );
        return;
      }


      if (selectedType == 'selected-many' && selectedMultiChoiceIndices.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least two correct answers for 'selected-many' type")),
        );
        return;
      }


      final updatedAnswers = (selectedType == 'drag-and-drop' || selectedType == 'fill-in-the-blank')
          ? extractedAnswers.map((answerText) => BasicAnswerModel(content: answerText, isCorrect: true)).toList()
          : answerControllers.map((controller) {
        String answerText = controller.text;
        bool isCorrect = false;

        if (selectedType == 'selected-one') {
          isCorrect = answerControllers.indexOf(controller) == selectedSingleChoiceIndex;
        } else if (selectedType == 'selected-many') {
          isCorrect = selectedMultiChoiceIndices.contains(answerControllers.indexOf(controller));
        } else if (selectedType == 'constructed') {
          answerText = shortAnswerController.text;
          isCorrect = true;
        }

        return BasicAnswerModel(content: answerText, isCorrect: isCorrect);
      }).toList();

      final updatedQuestion = EditQuestionPayloadModel(
        content: updatedContent,
        score: score.toInt(),
        type: selectedType,
        answers: updatedAnswers,
        id: widget.question.id,
      );
      editQuestionPayloadModel=updatedQuestion;
       context.read<ButtonStateCubit>().execute(
           usecase: EditQuestionUseCase(), params: updatedQuestion);
    }




    @override
    Widget build(BuildContext context) {
      return BlocProvider<ButtonStateCubit>(
        create: (BuildContext context) => ButtonStateCubit(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: GetLoading()));
                  }
                  if (state is ButtonFailureState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: GetFailure(name: state.errorMessage)));
                  }
                  if (state is ButtonSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(content: Center(child: Text("Success"))));
                    widget.parenContext.read<GetMyQuestionCubit>().onUpdate(editQuestionPayloadModel);
                    Navigator.of(context).pop();
                  }
                },
                child: SingleChildScrollView(
                  child: isEditing ? _buildEditView(context) : _buildDetailView(
                      context),
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
                  enterEditMode();
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
                    controller: contentController,
                  ),

                  const SizedBox(height: 16),
                  if (selectedType == 'constructed')
                    _buildTextField(
                      label: 'Correct Answer',
                      hint: 'Enter the correct answer...',
                      controller: shortAnswerController,
                    ),

                  if (selectedType == 'selected-one' ||
                      selectedType == 'selected-many')
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
      required TextEditingController controller,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
            onChanged: (value) {
              setState(() {
                isEdited = true;
              });

            },
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
            children: answerControllers
                .asMap()
                .entries
                .map((entry) {
              int index = entry.key;
              TextEditingController controller = entry.value;

              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
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
                        setState((  ) {
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
                        answerControllers.removeAt(index);
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
                answerControllers.add(
                    TextEditingController()); // Thêm mới 1 ô nhập liệu
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
