import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/data/post/models/comment_payload_modal.dart';
import 'package:quiz_app/domain/post/usecase/get_comment_usecase.dart';
import 'package:quiz_app/presentation/team/bloc/get_list_comment_state.dart';
import 'package:quiz_app/service_locator.dart';

class GetListCommentCubit extends Cubit<GetListCommentState> {
  GetListCommentCubit() : super(GetListCommentLoading());

  onGet(CommentPayloadModal comment) async {
    emit(GetListCommentLoading());
    try {
      final returnedData = await sl<GetCommentUseCase>().call(params: comment);
      returnedData.fold((error) => emit(GetListCommentFailure(error: error)),
              (data) => emit(GetListCommentSuccess(comments: data)));
    }
    catch (e)
    {
      emit(GetListCommentFailure(error: e.toString()));
    }
  }
}
