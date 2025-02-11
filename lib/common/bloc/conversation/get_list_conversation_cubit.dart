import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/conversation/get_list_conversaton_state.dart';
import 'package:quiz_app/core/constant/socket_service.dart';
import 'package:quiz_app/core/global_storage.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/conversation/models/conversation_model.dart';
import 'package:quiz_app/domain/conversation/entity/conversation_entity.dart';
import 'package:quiz_app/service_locator.dart';

class GetListConversationCubit extends Cubit<GetListConversationState> {
  GetListConversationCubit() : super(GetListConversationLoading());
  List<ConversationEntity> conversation = [];
  final _socketService = sl<SocketService>();

  onGet({dynamic params, required UseCase usecase}) async {
    emit(GetListConversationLoading());
    try {
      Either returnedData = await usecase.call(params: params);
      returnedData.fold((error) {
        emit(GetListConversationFailure(error: error));
      }, (data) async {
        conversation.clear();
        conversation.addAll(data);
        conversation = conversation.reversed.toList();
        emit(GetListConversationSuccess(conversations: conversation));
        final socket = await _socketService.socket;
        socket.emit("joinUserRoom", await GlobalStorage.getUserId());
        socket.on('updateConversationList', (data) {
          final entity = ConversationModel.fromMap(data).toEntity();
          int index = conversation
              .indexWhere((c) => c.conversationId == entity.conversationId);
          if (index != -1) {
            conversation.removeAt(index);
          }
          conversation.insert(0, entity);
          emit(GetListConversationSuccess(conversations: conversation));
        });
      });
    } catch (e) {
      print("ac" + e.toString());
      emit(GetListConversationFailure(error: e.toString()));
    }
  }
}
