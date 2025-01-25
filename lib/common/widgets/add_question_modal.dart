import 'package:flutter/material.dart';

class AddQuestionModal extends StatefulWidget {
  @override
  State<AddQuestionModal> createState() => _ModalContentState();
}

class _ModalContentState extends State<AddQuestionModal> {
  String selectedType = 'Short Question';
  String selectedDifficulty = 'Easy';
  double score = 0.0;

  final List<String> questionTypes = [
    'Short Question',
    'Single Choice',
    'Multiple Choice',
    'Fill in the Blank',
    'Drag and Drop'
  ];
  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];

  List<String> answers = [''];
  int? selectedSingleChoiceIndex;
  List<int> selectedMultiChoiceIndices = [];
  String shortAnswerCorrect = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
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
                          selectedType = value!;
                          answers = [''];
                          selectedSingleChoiceIndex = null;
                          selectedMultiChoiceIndices.clear();
                          shortAnswerCorrect = '';
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
                    _buildDropdown(
                      label: 'Difficulty',
                      value: selectedDifficulty,
                      items: difficulties,
                      onChanged: (value) {
                        setState(() {
                          selectedDifficulty = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Question Content',
                      hint: 'Enter your question here...',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    if (selectedType == 'Short Question')
                      _buildTextField(
                        label: 'Correct Answer',
                        hint: 'Enter the correct answer...',
                        onChanged: (value) {
                          setState(() {
                            shortAnswerCorrect = value;
                          });
                        },
                      ),
                    if (selectedType == 'Single Choice' || selectedType == 'Multiple Choice')
                      _buildAnswersSection(),
                    if (selectedType == 'Fill in the Blank' || selectedType == 'Drag and Drop')
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Use {answer} to specify blanks. Example: The capital of France is {Paris}.',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
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
          min: 0,
          max: 100,
          divisions: 20,
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
            return Row(
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
                if (selectedType == 'Single Choice')
                  Radio<int>(
                    value: index,
                    groupValue: selectedSingleChoiceIndex,
                    onChanged: (int? value) {
                      setState(() {
                        selectedSingleChoiceIndex = value;
                      });
                    },
                  ),
                if (selectedType == 'Multiple Choice')
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
