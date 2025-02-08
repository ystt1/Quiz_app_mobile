import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/quiz/entity/basic_quiz_entity.dart';
import 'package:quiz_app/domain/quiz/usecase/get_quiz_detail_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_quiz_detail_state.dart';
import 'package:quiz_app/service_locator.dart';

import '../../../domain/quiz/entity/topic_entity.dart';

class GetQuizDetailCubit extends Cubit<GetQuizDetailState> {
  GetQuizDetailCubit() : super(GetQuizDetailLoading());

  Future<void> onGet(String id) async {
    try {
      final returnedData = await sl<GetQuizDetailUseCase>().call(params: id);
      returnedData.fold((error) => emit(GetQuizDetailFailure(error: error)),
          (data) => (emit(GetQuizDetailSuccess(flag:(data as BasicQuizEntity).image,quiz: data))));
    } catch (e) {
      emit(GetQuizDetailFailure(error: e.toString()));
    }
  }

  onChangeStatus() {
    if(state is GetQuizDetailSuccess)
      {
        BasicQuizEntity currentQuiz=(state as GetQuizDetailSuccess).quiz;
        currentQuiz.status=currentQuiz.status=="active"?"inactive":"active";
        emit(GetQuizDetailSuccess(flag: (state as GetQuizDetailSuccess).flag,quiz: currentQuiz));
      }
  }

  onRemoveListQuiz(List<int> questions) {
    if(state is GetQuizDetailSuccess)
    {
      print(questions);
      BasicQuizEntity currentQuiz=(state as GetQuizDetailSuccess).quiz;
      questions.sort((a, b) => b.compareTo(a));

      for (int index in questions) {
        if (index >= 0 && index < currentQuiz.questions.length) {
          currentQuiz.questions.removeAt(index);
        }
      }
      currentQuiz.questionNumber-=questions.length;
      if(currentQuiz.questionNumber==0){
        currentQuiz.status='inactive';
      }
      emit(GetQuizDetailSuccess(flag:(state as GetQuizDetailSuccess).flag,quiz: currentQuiz));
    }
  }

  onAddListQuiz(List<BasicQuestionEntity> questions) {
    if(state is GetQuizDetailSuccess)
    {
      BasicQuizEntity currentQuiz=(state as GetQuizDetailSuccess).quiz;
      currentQuiz.questions.addAll(questions);
      currentQuiz.questionNumber+=questions.length;
      emit(GetQuizDetailSuccess(flag:(state as GetQuizDetailSuccess).flag,quiz: currentQuiz));
    }
  }


  onEditQuiz(String name,String description, List<TopicEntity> topics,int time) {
    if(state is GetQuizDetailSuccess)
    {
      BasicQuizEntity currentQuiz=(state as GetQuizDetailSuccess).quiz;
      currentQuiz.name=name;
      currentQuiz.description=description;
      currentQuiz.topicId=topics;
      currentQuiz.time=time;
      emit(GetQuizDetailSuccess(flag: (state as GetQuizDetailSuccess).flag,quiz: currentQuiz));
    }
  }

  onChangeImage(String image)
  {
    if(state is GetQuizDetailSuccess && image!=null)
    {
      BasicQuizEntity currentQuiz=(state as GetQuizDetailSuccess).quiz;
      emit(GetQuizDetailSuccess(flag: image,quiz: currentQuiz));
    }
  }

  onSaveImage()
  {
    if(state is GetQuizDetailSuccess)
    {
      BasicQuizEntity currentQuiz=(state as GetQuizDetailSuccess).quiz;
      currentQuiz.image=(state as GetQuizDetailSuccess).flag!;
      emit(GetQuizDetailSuccess(flag: (state as GetQuizDetailSuccess).flag,quiz: currentQuiz));
    }
  }
}
