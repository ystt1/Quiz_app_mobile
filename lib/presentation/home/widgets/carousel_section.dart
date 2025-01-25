import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/presentation/home/bloc/get_hot_quiz_cubit.dart';
import 'package:quiz_app/presentation/home/bloc/get_hot_quiz_state.dart';
import 'package:quiz_app/presentation/home/widgets/slider_card.dart';

class CarouselSection extends StatelessWidget {
  const CarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<GetHotQuizCubit, GetHotQuizState>(
            builder: (BuildContext context, state) {
              if (state is GetHotQuizLoading) {
                return const GetLoading();
              }
              if (state is GetHotQuizFailure) {
                return  GetFailure(name: state.error);
              }
              if (state is GetHotQuizSuccess) {
                return CarouselSlider(
                  items: state.hotQuiz.map((BasicQuizEntity quiz) {
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
    );
  }
}
