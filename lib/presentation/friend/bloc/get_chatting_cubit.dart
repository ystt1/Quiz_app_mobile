
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/core/constant/socket_service.dart';
import 'package:quiz_app/core/global_storage.dart';
import 'package:quiz_app/data/conversation/models/message_model.dart';
import 'package:quiz_app/domain/conversation/usecase/get_message_usecase.dart';
import 'package:quiz_app/presentation/friend/bloc/get_chatting_state.dart';
import 'package:quiz_app/service_locator.dart';

class GetChattingCubit extends Cubit<GetChattingState> {
  GetChattingCubit() : super(GetChattingLoading());
  List<MessageModel> messages=[];
  final _socketService = sl<SocketService>();

  Future<void> onGet(String userId) async {
    emit(GetChattingLoading());
    try {
      final returnedData = await sl<GetMessageUseCase>().call(
        params: userId,
      );

      returnedData.fold((error) => emit(GetChattingFailure(error: error)),
              (data) async {
                messages.clear();
                messages.addAll(data);
            emit(GetChattingSuccess(messages: data));

            final socket = await _socketService.socket;


            socket.off('newMessage');


            socket.emit('joinConversation', {
              "senderId": await GlobalStorage.getUserId(),
              "receiverId": userId
            });


            socket.on('newMessage', (data) {
              var message= MessageModel.fromMap(data);
              messages.add(message);
              emit(GetChattingSuccess(messages: messages));
            });
          }
      );
    } catch (e) {
      print(e.toString());
      emit(GetChattingFailure(error: e.toString()));
    }
  }


  Future<void> onSendMessage(String content, String receiverId) async {
    final newMessage = {
      "content": content,
      "senderId": await GlobalStorage.getUserId(),
      'receiverId': receiverId
    };

    final socket = await _socketService.socket;
    socket.emit('sendMessage', newMessage);
  }
}
