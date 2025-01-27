import 'package:flutter/material.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';


class PracticeQuizDetailPage extends StatelessWidget {
  final BasicQuizEntity quiz;
  const PracticeQuizDetailPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Stack(
                      children: [
                        Image.network(
                          quiz.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            quiz.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz.name,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              Text(
                                'Questions: ${quiz.questionNumber}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Duration: ${quiz.time} min',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the quiz page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Start Quiz',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // TabBar Section
                  Container(
                    color: Colors.white,
                    child: const TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Introduction'),
                        Tab(text: 'Leaderboard'),
                        Tab(text: 'Comments'),
                      ],
                    ),
                  ),
                  // TabBar View
                  Container(
                    height: MediaQuery.of(context).size.height - 300,
                    child: TabBarView(
                      children: [
                        // Introduction Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Participants: 150',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const Text(
                                'Favorites: 50',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Description:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               Text(
                              quiz.description
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Topics:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                               Wrap(
                                children: [
                                  ...quiz.topicId.map((e) => Chip(label: Text(e.name))).toList(),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Other Quizzes by Owner:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 210,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 150,
                                      margin: const EdgeInsets.only(right: 16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Center(child: Text('Quiz ${index + 1}')),
                                    );
                                  },
                                  itemCount: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Leaderboard Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Top 5 Participants',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DataTable(
                                columns: const [
                                  DataColumn(label: Text('Rank')),
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Score')),
                                ],
                                rows: List.generate(5, (index) {
                                  return DataRow(cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(Text('User ${index + 1}')),
                                    DataCell(Text('${90 - index}')),
                                  ]);
                                }),
                              ),
                            ],
                          ),
                        ),
                        // Comments Tab
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to comments page
                            },
                            child: const Text('Go to Comments'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

