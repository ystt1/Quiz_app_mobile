import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/result/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/result/get_list_result_state.dart';
import 'package:quiz_app/common/widgets/center_text.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/quiz/entity/result_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/get_list_result_usecase.dart';
import 'package:quiz_app/presentation/history/pages/result_page.dart';
import 'package:quiz_app/presentation/history/widgets/result_card.dart';

class GetQuizResultPage extends StatelessWidget {
  final String idQuiz;
  const GetQuizResultPage({super.key, required this.idQuiz});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                    context.read<GetListResultCubit>().execute(usecase: GetListResultUseCase(),params: 'idQuiz=$idQuiz');
                  },
                  child: Column(
                    children: [

                      BlocBuilder<GetListResultCubit, GetListResultState>(
                          builder: (BuildContext context, GetListResultState state) {
                            if (state is GetListResultLoading) {
                              return const GetLoading();
                            }
                            if (state is GetListResultFailure) {
                              return GetFailure(name: state.error);
                            }
                            if (state is GetListResultSuccess) {
                              List<ResultEntity> results = state.results.where((e) => e.quizId.id != idQuiz).toList();

                              if (results.isEmpty) {
                                return const Expanded(child: CenterText(text: "Not found any history"));
                              }
                              return Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(10),
                                  itemCount: results.length,
                                  itemBuilder: (context, index) {
                                    final result = results[index];
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
