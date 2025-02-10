import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_cubit.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/domain/quiz/usecase/get_newest_quiz_usecase.dart';
import 'package:quiz_app/domain/quiz/usecase/get_recent_quiz_usecase.dart';
import 'package:quiz_app/presentation/home/widgets/carousel_section.dart';
import 'package:quiz_app/presentation/home/widgets/header.dart';
import 'package:quiz_app/presentation/home/widgets/section_header.dart';
import '../../../common/bloc/quiz/get_list_quiz_cubit_2.dart';
import '../../../common/bloc/quiz/get_list_quiz_cubit_3.dart';
import '../../../common/bloc/quiz/get_list_quiz_state_2.dart';
import '../../../common/bloc/quiz/get_list_quiz_state_3.dart';
import '../../../common/widgets/big_quiz_card.dart';
import '../../../common/widgets/get_loading.dart';
import '../../../common/widgets/get_failure.dart';
import '../../../common/widgets/get_something_wrong.dart';
import '../../../domain/quiz/entity/basic_quiz_entity.dart';
import '../../../domain/quiz/usecase/get_hot_quiz_usecase.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late int _selectedRecentQuiz = 0;
  late int _selectedNewQuiz = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>GetListQuizCubit()..execute(usecase: GetHotQuizUseCase(),params: "filterType=hot")),
        BlocProvider(create: (_)=>GetListQuizCubit2()..execute(usecase: GetNewestQuizUseCase())),
        BlocProvider(create: (_)=>GetListQuizCubit3()..execute(usecase: GetRecentQuizUseCase())),
      ],
      child: BlocProvider(
        create: (BuildContext context) =>GetUserDetailCubit()..onGet("")
      ,
        child: Builder(
          builder: (context) {
            return RefreshIndicator(
              onRefresh: () async{
                context.read<GetListQuizCubit>()..execute(usecase: GetHotQuizUseCase(),params: "filterType=hot");
                context.read<GetListQuizCubit2>()..execute(usecase: GetNewestQuizUseCase());
                context.read<GetListQuizCubit3>()..execute(usecase: GetRecentQuizUseCase());
              },
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: const Header(),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CarouselSection(),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        _recentSection(),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        _newestSection(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _recentSection() {
    return
       Column(
        children: [
          const SectionHeader(title: "Recent"),
          BlocBuilder<GetListQuizCubit2, GetListQuizState2>(
            builder: (BuildContext context, GetListQuizState2 state) {
              if (state is GetListQuizLoading2) {
                return const GetLoading();
              }
              if (state is GetListQuizFailure2) {
                return GetFailure(name: state.error);
              }
              if (state is GetListQuizSuccess2) {
                return Column(
                  children: [
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRecentQuiz = index;
                                });
                              },
                              child: _smallPictureQuiz(state.quizzes[index],
                                  _selectedRecentQuiz == index));
                        },
                        itemCount: state.quizzes.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 10);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    BigQuizCard(quiz: state.quizzes[_selectedRecentQuiz]),
                  ],
                );
              }
              return const GetSomethingWrong();
            },
          ),
        ],

    );
  }

  Widget _newestSection() {
    return Column(
        children: [
          const SectionHeader(title: "Newest"),
          BlocBuilder<GetListQuizCubit3, GetListQuizState3>(
            builder: (BuildContext context, GetListQuizState3 state) {
              if (state is GetListQuizLoading3) {
                return const GetLoading();
              }
              if (state is GetListQuizFailure3) {
                return GetFailure(name: state.error);
              }
              if (state is GetListQuizSuccess3) {
                return Column(
                  children: [
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedNewQuiz = index;
                                });
                              },
                              child: _smallPictureQuiz(state.quizzes[index],
                                  _selectedNewQuiz == index));
                        },
                        itemCount: state.quizzes.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 10);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    BigQuizCard(quiz: state.quizzes[_selectedNewQuiz]),
                  ],
                );
              }
              return const GetSomethingWrong();
            },
          ),
        ],

    );
  }

  Widget _smallPictureQuiz(BasicQuizEntity quiz, bool isSelected) {
    return Container(
      height: 80,
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: isSelected ? 1 : 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Base64ImageWidget(base64String:quiz.image ,)),
    );
  }
}
