import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/quiz/entity/topic_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/get_hot_quiz_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_all_topic_state.dart';
import 'package:quiz_app/presentation/library/widget/quiz_list.dart';
import 'package:quiz_app/presentation/search/bloc/get_list_quiz_search_state.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isFilterExpanded = false;
  List<TopicEntity> selectedTopics = [];
  RangeValues timeRange = const RangeValues(0, 1800);
  RangeValues questionRange = const RangeValues(0, 100);
  String sortBy = "CreatedAt";
  void searchQuizzes(BuildContext context) {
    late String params="";
    params+=_searchController.text!=""?"name=${_searchController.text}&":"";
    selectedTopics.forEach((e) => params += "topics=${e.id}&");
    // params+=sortBy!=""?"sortField=$sortBy&":"";
    params += "minTime=${timeRange.start.toInt()}&maxTime=${timeRange.end.toInt()}&";
    params += "minQuestions=${questionRange.start.toInt()}&maxQuestions=${questionRange.end.toInt()}&";
    context.read<GetListQuizCubit>().execute(usecase: GetHotQuizUseCase(),params:params);
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
                  GetListQuizCubit()..execute(usecase: GetHotQuizUseCase(),params: "")),
          BlocProvider(
              create: (BuildContext context) =>
              GetAllTopicCubit()..onGet()),
          BlocProvider(
              create: (BuildContext context) =>
              ButtonStateCubit()),
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                            labelText: "Enter Quiz Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      // Bộ lọc theo topic
                      BlocBuilder<GetAllTopicCubit, GetAllTopicState>(
                        builder: (BuildContext context, GetAllTopicState state) {
                          if (state is GetAllTopicLoading) {
                            return const GetLoading();
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
                          return const GetSomethingWrong();
                        },
                      ),
                      // Lọc thời gian
                      ListTile(
                        title: const Text("time (second)"),
                        subtitle: RangeSlider(
                          values: timeRange,
                          min: 0,
                          max: 1800,
                          divisions: 30,
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
                        title: const Text("Question Number"),
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
                        title: const Text("SortBy"),
                        trailing: DropdownButton<String>(
                          value: sortBy,
                          items: [
                            "CreatedAt",
                            "Participants",
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
                      Builder(
                        builder: (context) {
                          return ElevatedButton(
                            onPressed: ()=>searchQuizzes(context),
                            child: const Text("Search"),
                          );
                        }
                      ),
                    ],
                  ],
                ),
              ),

              Expanded(
                child:
                    BlocBuilder<GetListQuizCubit, GetListQuizState>(
                  builder:
                      (BuildContext context, GetListQuizState state) {
                    if (state is GetListQuizLoading) {
                      return const GetLoading();
                    }
                    if (state is GetListQuizFailure) {
                      return GetFailure(name: state.error);
                    }
                    if (state is GetListQuizSuccess) {
                      if (state.quizzes.isEmpty) {
                        return const GetFailure(name: "Not Found");
                      }
                      return QuizList(
                        quizList: state.quizzes,
                        isYour: false,
                      );
                    }
                    return const Center(child: Text("didn't search"),);
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
