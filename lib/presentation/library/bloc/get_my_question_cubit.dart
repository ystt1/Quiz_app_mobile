import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/widgets/add_question_modal.dart';
import 'package:quiz_app/data/question/models/basic_answer_model.dart';
import 'package:quiz_app/data/question/models/edit_question_payload_model.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';
import 'package:quiz_app/domain/question/entity/basic_question_entity.dart';
import 'package:quiz_app/domain/question/usecase/get_my_question_usecase.dart';
import 'package:quiz_app/presentation/library/bloc/get_my_question_state.dart';

import '../../../service_locator.dart';

class GetMyQuestionCubit extends Cubit<GetMyQuestionState> {
  GetMyQuestionCubit() : super(GetMyQuestionLoading());

  Future<void> onGet(SearchAndSortModel searchSort) async {
    try {
      final response = await sl<GetMyQuestionUseCase>().call(params: searchSort);
      response.fold((error) => emit(GetMyQuestionFailure(error: error)),
          (data) => emit(GetMyQuestionSuccess(questions: data)));
    } catch (e) {
      emit(GetMyQuestionFailure(error: e.toString()));
    }
  }

  onRemove(int index)
  {
    if(state is GetMyQuestionSuccess)
      {
        List<BasicQuestionEntity> questions=(state as GetMyQuestionSuccess).questions;
        questions.removeAt(index);
        emit(GetMyQuestionSuccess(questions: questions));
      }
  }

  onUpdate(EditQuestionPayloadModel? question) {
    if (state is GetMyQuestionSuccess && question!=null) {
      List<BasicQuestionEntity> questions = (state as GetMyQuestionSuccess)
          .questions
          .map((e) {
        if (e.id == question.id) {
          return BasicQuestionEntity(
            content: question.content,
            answers: question.answers.map((e)=>e.toEntity()).toList(),
            score: question.score, id: e.id, type:e.type, dateCreated:e.dateCreated,
          );
        }
        return e;
      })
          .toList(); // Tạo danh sách mới

      emit(GetMyQuestionSuccess(questions: questions));
    }
  }


}
