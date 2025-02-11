import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/result/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/result/get_list_result_state.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/search_sort.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/domain/quiz/usecase/get_list_result_usecase.dart';
import 'package:quiz_app/presentation/history/pages/result_page.dart';
import 'package:quiz_app/presentation/history/widgets/result_card.dart';

import '../../../common/widgets/center_text.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  void onSearch(BuildContext context, SearchAndSortModel searchSort) {
    late String params = '';
    if (searchSort.name != "") {
      params += 'quizName=${searchSort.name}&';
    }
    if (searchSort.sortField == "createdAt") {
      params += 'sortBy=date&sortOrder=${searchSort.direction}';
    }
    if (searchSort.sortField == "best") {
      params += 'sortBy=leaderboard&sortOrder=${searchSort.direction}';
    }
    context
        .read<GetListResultCubit>()
        .execute(usecase: GetListResultUseCase(), params: params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
          centerTitle: true,

        ),
        body: BlocProvider(
          create: (BuildContext context) => GetListResultCubit()
            ..execute(usecase: GetListResultUseCase(), params: ''),
          child: Builder(
            builder: (context) {
              return RefreshIndicator(
                onRefresh: ()async {
                  context.read<GetListResultCubit>().execute(usecase: GetListResultUseCase(),params: '');
                },
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      return SearchSort(
                        onSearch: (state) {
                          onSearch(context, state);
                        },
                        type: "history",
                      );
                    }),
                    BlocBuilder<GetListResultCubit, GetListResultState>(
                        builder: (BuildContext context, GetListResultState state) {
                      if (state is GetListResultLoading) {
                        return const GetLoading();
                      }
                      if (state is GetListResultFailure) {
                        return GetFailure(name: state.error);
                      }
                      if (state is GetListResultSuccess) {
                        if (state.results.isEmpty) {
                            return const Expanded(child: CenterText(text: "Not found any history"));
                        }
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: state.results.length,
                            itemBuilder: (context, index) {
                              final result = state.results[index];
                              return GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResultPage(result: result)),
                                      ),
                                  child: ResultCard(result: result));
                            },
                          ),
                        );
                      }
                      return const GetSomethingWrong();
                    }),
                  ],
                ),
              );
            }
          ),
        ));
  }
}
