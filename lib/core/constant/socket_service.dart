
import 'dart:async';

import 'package:quiz_app/core/constant/url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../data/api_service.dart';

class SocketService {

  late IO.Socket _socket;
  final Completer<void> _socketInitialized = Completer<void>();

  SocketService() {
    initSocket();
  }

  Future<void> initSocket() async {

    _socket = IO.io(
      '$url',
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3OTYyNWE0YWZkNmU4YWVkYzhmYzY0YSIsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MzkwMDkxODksImV4cCI6MTc0MTYwMTE4OX0.peZCgs9VIXbYZg2DAspPVytT68Jqh_cLbMPuMx4c3uw"})
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print('Socket connected: ${_socket.id}');
      if (!_socketInitialized.isCompleted) {
        _socketInitialized.complete(); // Mark initialization as completed
      }
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  Future<IO.Socket> get socket async {
    await _socketInitialized.future; // Wait for socket to be initialized
    return _socket;
  }
}
