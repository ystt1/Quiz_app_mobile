import 'package:flutter/material.dart';
import 'package:quiz_app/common/widgets/question_card.dart';
import 'package:quiz_app/data/question/models/basic_answer_model.dart';
import 'package:quiz_app/domain/question/entity/basic_answer_entity.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/quiz/entity/quiz_entity.dart';

import '../../../data/question/models/basic_question_model.dart';

class QuizDetailPage extends StatefulWidget {
  final QuizEntity quiz;
  const QuizDetailPage({super.key, required this.quiz});

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  late bool isPrivate;

  @override
  void initState() {
    super.initState();
    isPrivate = widget.quiz.isPrivate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.quizName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Edit action
            },
            icon: Icon(Icons.edit),
            tooltip: 'Edit Quiz',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quiz Image with Edit Button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GestureDetector(
                      onTap: () {
                        // Action when tapping the image
                      },
                      child: Image.network(
                        widget.quiz.quizImageUrl,
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
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      color: Colors.black45,
                      iconSize: 28,
                      tooltip: 'Edit Image',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.quiz.quizDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 8),

              // Quiz Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Duration: ${widget.quiz.time} mins",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey.shade700),
                    ),
                    Text(
                      "Created: ${widget.quiz.createdDate}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Topics
              Padding(
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
                      children: widget.quiz.topics
                          .map((topic) => Chip(
                        label: Text(topic, style: TextStyle(fontSize: 12)),
                        backgroundColor: Colors.grey.shade200,
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Privacy Toggle
              Padding(
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
                        Text("Private"),
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
              ),
              const SizedBox(height: 16),

              // Questions List
              Text(
                "Questions",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: QuestionCard(question: BasicQuestionEntity(
                      id: 'q4',
                      content: 'Fill in the blank: "The sun rises in the ____."',
                      score: '10',
                      type: 'fill_in_the_blank',
                      dateCreated: '29/01/2024',
                      answers: [
                        BasicAnswerEntity(id: 'a1', content: 'East', isCorrect: true),
                      ],
                    ),),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Add Question Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add question action
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Question"),
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
    );
  }
}