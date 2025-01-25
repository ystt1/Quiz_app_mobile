import 'package:flutter/material.dart';

class AddQuizModal extends StatefulWidget {
  const AddQuizModal({Key? key}) : super(key: key);

  @override
  State<AddQuizModal> createState() => _AddQuizModalState();
}

class _AddQuizModalState extends State<AddQuizModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String quizImageUrl = '';
  final List<String> topics = ['Math', 'Science', 'History', 'Literature'];
  final List<String> selectedTopics = []; // Danh sách các topic đã chọn

  void _saveQuiz() {
    String quizName = _nameController.text;
    String quizDescription = _descriptionController.text;
    String quizTime = _timeController.text;

    if (quizName.isEmpty ||
        quizDescription.isEmpty ||
        quizImageUrl.isEmpty ||
        quizTime.isEmpty ||
        selectedTopics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select at least one topic')),
      );
      return;
    }

    // Handle saving logic here
    Navigator.pop(context); // Close the modal after saving
  }

  void _toggleTopic(String topic) {
    setState(() {
      if (selectedTopics.contains(topic)) {
        selectedTopics.remove(topic);
      } else {
        selectedTopics.add(topic);
      }
    });
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Ensure modal height adapts to content
        children: [
          Center(
            child: Text(
              'Add a New Quiz',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('Quiz Name'),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter quiz name...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('Description'),
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
          SizedBox(height: 16),
          Text('Quiz Image URL'),
          TextField(
            onChanged: (value) {
              quizImageUrl = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter image URL or local image name...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('Topics'),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: topics.map((topic) {
              return FilterChip(
                label: Text(topic),
                selected: selectedTopics.contains(topic),
                onSelected: (isSelected) {
                  _toggleTopic(topic);
                },
                selectedColor: Colors.blueAccent.withOpacity(0.2),
                backgroundColor: Colors.grey.shade200,
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text('Time (in minutes)'),
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
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveQuiz,
            child: Text('Save Quiz'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
