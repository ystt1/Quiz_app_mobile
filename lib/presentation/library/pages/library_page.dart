import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/add_question_modal.dart';
import 'package:quiz_app/common/widgets/add_quiz_modal.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/common/widgets/question_card.dart';
import 'package:quiz_app/common/widgets/search_sort.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_question_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_question_state.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_quiz_cubit.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_quiz_state.dart';
import 'package:quiz_app/presentation/library/widget/quiz_list.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => GetMyQuizCubit()..onGet()),
          BlocProvider(
              create: (BuildContext context) => GetMyQuestionCubit()..onGet()),
        ],
        child: Column(
          children: [
            // Tab Selector with modern design
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabButton('Quiz', 0),
                  _buildTabButton('Question', 1),
                ],
              ),
            ),

            const SearchSort(),
            // Content Area
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _selectedTabIndex == 0
                      ? _buildQuizList()
                      : _buildQuestionList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) => _selectedTabIndex==1?AddQuestionModal():AddQuizModal(),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizList() {
    return BlocBuilder<GetMyQuizCubit, GetMyQuizState>(
        builder: (BuildContext context, state) {
      if (state is GetMyQuizLoading) {
        return const GetLoading();
      }
      if (state is GetMyQuizFailure) {
        return  GetFailure(name: state.error);
      }
      if (state is GetMyQuizSuccess) {
        return QuizList(quizList: state.myQuiz,isYour: true,);
      }
      return const GetSomethingWrong();
    });
  }

  Widget _buildQuestionList() {
    return BlocBuilder<GetMyQuestionCubit, GetMyQuestionState>(
        builder: (BuildContext context, state) {
          if (state is GetMyQuestionLoading) {
            return const GetLoading();
          }
          if (state is GetMyQuestionFailure) {
            return  GetFailure(name: state.error);
          }
          if (state is GetMyQuestionSuccess) {
            return ListView.builder(itemBuilder: (context,index){
              return QuestionCard(question: state.questions[index]);
            },
              itemCount: state.questions.length,

            );
          }
          return const GetSomethingWrong();
        });
  }
}
