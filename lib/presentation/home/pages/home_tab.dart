import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/presentation/home/bloc/get_new_quiz_cubit.dart';
import 'package:quiz_app/presentation/home/widgets/carousel_section.dart';
import 'package:quiz_app/presentation/home/widgets/header.dart';
import 'package:quiz_app/presentation/home/widgets/section_header.dart';
import '../../../common/widgets/big_quiz_card.dart';
import '../../../common/widgets/get_loading.dart';
import '../../../common/widgets/get_failure.dart';
import '../../../common/widgets/get_something_wrong.dart';
import '../../../domain/quiz/entity/basic_quiz_entity.dart';
import '../bloc/get_new_quiz_state.dart';
import '../bloc/get_recent_quiz_state.dart';
import '../bloc/get_hot_quiz_cubit.dart';
import '../bloc/get_recent_quiz_cubit.dart';

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Header(),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => GetHotQuizCubit()..onGet()),
          BlocProvider(
              create: (BuildContext context) => GetRecentQuizCubit()..onGet()),
          BlocProvider(
              create: (BuildContext context) => GetNewQuizCubit()..onGet()),
        ],
        child: Padding(
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



  Widget _recentSection() {
    return Column(
      children: [
        const SectionHeader(title: "Recent"),
        BlocBuilder<GetRecentQuizCubit, GetRecentQuizState>(
          builder: (BuildContext context, GetRecentQuizState state) {
            if (state is GetRecentQuizLoading) {
              return const GetLoading();
            }
            if (state is GetRecentQuizFailure) {
              return  GetFailure(name: state.error);
            }
            if (state is GetRecentQuizSuccess) {
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
                            child: _smallPictureQuiz(state.recentQuiz[index],_selectedRecentQuiz==index));
                      },
                      itemCount: state.recentQuiz.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 10);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  BigQuizCard(quiz: state.recentQuiz[_selectedRecentQuiz]),
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
        BlocBuilder<GetNewQuizCubit, GetNewQuizState>(
          builder: (BuildContext context, GetNewQuizState state) {
            if (state is GetNewQuizLoading) {
              return const GetLoading();
            }
            if (state is GetNewQuizFailure) {
              return GetFailure(name: state.error);
            }

            if (state is GetNewQuizSuccess) {
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
                                child:
                                    _smallPictureQuiz(state.newQuiz[index],_selectedNewQuiz==index));
                      },
                      itemCount: state.newQuiz.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 10);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  BigQuizCard(quiz: state.newQuiz[_selectedNewQuiz]),
                ],
              );
            }
            return const GetSomethingWrong();
          },
        ),
      ],
    );
  }

  Widget _smallPictureQuiz(BasicQuizEntity quiz,bool isSelected) {
    return Container(
      height: 80,
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black,width:isSelected? 1:0.3),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(quiz.imgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }


}
