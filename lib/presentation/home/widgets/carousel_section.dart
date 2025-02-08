import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_cubit.dart';
import 'package:quiz_app/common/bloc/quiz/get_list_quiz_state.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/get_hot_quiz_usecase.dart';
import 'package:quiz_app/presentation/home/widgets/slider_card.dart';

class CarouselSection extends StatelessWidget {
  const CarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>GetListQuizCubit()..execute(usecase: GetHotQuizUseCase(),params: "filterType=hot"),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<GetListQuizCubit, GetListQuizState>(
              builder: (BuildContext context, GetListQuizState state) {
                if (state is GetListQuizLoading) {
                  return const GetLoading();
                }
                if (state is GetListQuizFailure) {
                  return  GetFailure(name: state.error);
                }
                if (state is GetListQuizSuccess) {
                  return CarouselSlider(
                    items: state.quizzes.map((BasicQuizEntity quiz) {
                      return SliderCard(quiz: quiz);
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      height: 220,
                    ),
                  );
                }
                return const GetSomethingWrong();
              },
            ),
          ],
        ),
      ),
    );
  }
}
