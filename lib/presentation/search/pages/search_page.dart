import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_state.dart';
import 'package:quiz_app/presentation/library/widget/quiz_list.dart';
import 'package:quiz_app/presentation/search/bloc/get_list_quiz_search_cubit.dart';
import 'package:quiz_app/presentation/search/bloc/get_list_quiz_search_state.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isFilterExpanded = false;
  List<TopicEntity> selectedTopics = [];
  RangeValues timeRange = const RangeValues(0, 60);
  RangeValues questionRange = const RangeValues(0, 100);
  String sortBy = "Số lượng người tham gia";
  List<String> topics = ["Math", "Science", "History"];
  List<Map<String, dynamic>> quizzes = [];

  void searchQuizzes() {
    //context.read<GetListQuizSearchCubit>()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Quizzes"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) =>
                  GetListQuizSearchCubit()..onGet("")),
          BlocProvider(
              create: (BuildContext context) =>
              GetAllTopicCubit()..onGet()),
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Bộ lọc và input
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                constraints: BoxConstraints(
                  maxHeight: isFilterExpanded ? MediaQuery.of(context).size.height * 0.8 : 70,
                ),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Bộ lọc",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            isFilterExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.filter_list,
                          ),
                          onPressed: () {
                            setState(() {
                              isFilterExpanded = !isFilterExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                    if (isFilterExpanded) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: "Nhập tên quiz",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      // Bộ lọc theo topic
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
                              spacing: 10,
                              children: state.topics.map((topic) {
                                return FilterChip(
                                  label: Text(topic.name),
                                  selected: selectedTopics.contains(topic),
                                  onSelected: (isSelected) {
                                    setState(() {
                                      isSelected
                                          ? selectedTopics.add(topic)
                                          : selectedTopics.remove(topic);
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          }
                          return GetSomethingWrong();
                        },
                      ),
                      // Lọc thời gian
                      ListTile(
                        title: const Text("Thời gian làm quiz (phút)"),
                        subtitle: RangeSlider(
                          values: timeRange,
                          min: 0,
                          max: 60,
                          divisions: 3,
                          labels: RangeLabels(
                            "${timeRange.start.toInt()}",
                            "${timeRange.end.toInt()}",
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              timeRange = values;
                            });
                          },
                        ),
                      ),
                      // Lọc số lượng câu hỏi
                      ListTile(
                        title: const Text("Số lượng câu hỏi"),
                        subtitle: RangeSlider(
                          values: questionRange,
                          min: 0,
                          max: 100,
                          divisions: 3,
                          labels: RangeLabels(
                            "${questionRange.start.toInt()}",
                            "${questionRange.end.toInt()}",
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              questionRange = values;
                            });
                          },
                        ),
                      ),
                      // Sắp xếp
                      ListTile(
                        title: const Text("Sắp xếp theo"),
                        trailing: DropdownButton<String>(
                          value: sortBy,
                          items: [
                            "Số lượng người tham gia",
                            "Ngày tạo",
                          ].map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              sortBy = value!;
                            });
                          },
                        ),
                      ),
                      // Nút tìm kiếm
                      ElevatedButton(
                        onPressed: searchQuizzes,
                        child: const Text("Tìm kiếm"),
                      ),
                    ],
                  ],
                ),
              ),

              Expanded(
                child:
                    BlocBuilder<GetListQuizSearchCubit, GetListQuizSearchState>(
                  builder:
                      (BuildContext context, GetListQuizSearchState state) {
                    if (state is GetListQuizSearchLoading) {
                      return const GetLoading();
                    }
                    if (state is GetListQuizSearchFailure) {
                      return GetFailure(name: state.error);
                    }
                    if (state is GetListQuizSearchSuccess) {
                      if (state.listQuiz.isEmpty) {
                        return const GetFailure(name: "Not Found");
                      }
                      return QuizList(
                        quizList: state.listQuiz,
                        isYour: false,
                      );
                    }
                    return const GetSomethingWrong();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
