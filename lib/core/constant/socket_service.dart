
import 'dart:async';

import 'package:quiz_app/core/constant/url.dart';
import 'package:quiz_app/core/global_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../data/api_service.dart';

class SocketService {

  late IO.Socket _socket;
  final Completer<void> _socketInitialized = Completer<void>();
  final TokenService _tokenService;

  SocketService(this._tokenService) {
    initSocket();
  }

  Future<void> initSocket() async {
    String? token= await _tokenService.getAccessToken();
    _socket = IO.io(
      '$baseUrl',
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': "Bearer $token"})
          .build(),
    );
    print("abcd");
    _socket.connect();

    _socket.onConnect((_) async {
      print('Socket connected: ${_socket.id}');

      if (!_socketInitialized.isCompleted) {
        _socketInitialized.complete();
        print(" Socket Initialized");// Mark initialization as completed
      }
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  Future<IO.Socket> get socket async {
    await _socketInitialized.future;
    print("Socket initialized successfully, returning socket instance.");
    return _socket;
  }
}
