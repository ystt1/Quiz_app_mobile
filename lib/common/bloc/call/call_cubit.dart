import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:quiz_app/common/bloc/call/call_state.dart';
import 'package:quiz_app/core/global_storage.dart';
import 'package:quiz_app/data/user/model/simple_user_model.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../core/constant/socket_service.dart';
import '../../../service_locator.dart';

class CallCubit extends Cubit<CallState> {
  RTCPeerConnection? _peerConnection;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  String? receiverId;
  final _socketService = sl<SocketService>();

  CallCubit() : super(CallStateInitial()) {
    print("🌀 CallCubit initialized");
    initialize();
  }

  Future<void> initialize() async {
    try {
      print("abc");
      final socket = await _socketService.socket;
      print("xyz");
      await localRenderer.initialize();
      await remoteRenderer.initialize();
      await _createPeerConnection();

      // Nhận ICE Candidate từ server
      socket.on("iceCandidate", (data) async {
        if (_peerConnection != null) {
          print("❄️ Nhận ICE Candidate từ server");
          await _peerConnection!.addCandidate(
            RTCIceCandidate(
              data["candidate"]["candidate"],
              data["candidate"]["sdpMid"],
              data["candidate"]["sdpMLineIndex"],
            ),
          );
        }
      });
      print("xzz");
      // Nhận cuộc gọi đến
      socket.on("callIncoming", (data) {
        print("📞 Incoming call from ${data['email']}");
        _handleIncomingCall(data);
      });

      // Nhận answer từ người nhận
      socket.on("callAccepted", (data) async {
        print("📞 Answer received from callee");

        if (_peerConnection == null) return;

        RTCSessionDescription remoteDesc = RTCSessionDescription(
            data["signal"]["sdp"], data["signal"]["type"]);

        await _peerConnection!.setRemoteDescription(remoteDesc);
        if (!isClosed) {
          final user = SimpleUserModel.fromMap(data).toEntity();
          emit(CallStateSuccess(user: user));
        }
      });
    } catch (e) {
      print("❌ Error initializing WebRTC: $e");
    }
  }

  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection(
      {
        "iceServers": [
          {"urls": "stun:stun.l.google.com:19302"}
        ]
      },
    );

    _peerConnection!.onIceCandidate = (candidate) async {
      final socket = await _socketService.socket;
      print("❄️ Gửi ICE Candidate");
      socket.emit("iceCandidate", {
        "to": receiverId,
        "candidate": {
          "candidate": candidate.candidate,
          "sdpMid": candidate.sdpMid,
          "sdpMLineIndex": candidate.sdpMLineIndex,
        }
      });
    };

    _peerConnection!.onTrack = (event) async {
      if (event.track.kind == "video") {
        remoteRenderer.srcObject = event.streams[0];
      }
    };
  }

  void _handleIncomingCall(Map<String, dynamic> data) {
    final entity = SimpleUserModel.fromMap(data).toEntity();
    receiverId = entity.id;
    emit(CallStateLoading(
      user: entity,
      signal_sdp: data["signal"]["sdp"],
      signal_type: data["signal"]["type"],
    ));
  }

  Future<void> startCall(SimpleUserEntity receiver) async {
    emit(CallStateWaiting(user: receiver));
    receiverId = receiver.id;

    // Lấy stream camera & microphone
    MediaStream stream = await navigator.mediaDevices.getUserMedia({
      "video": true,
      "audio": true,
    });

    for (var track in stream.getTracks()) {
      _peerConnection!.addTrack(track, stream);
    }

    localRenderer.srcObject = stream;

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    final socket = await _socketService.socket;
    socket.emit("callUser", {
      "from": await GlobalStorage.getUserId(),
      "to": receiverId,
      "signal": offer.toMap(),
    });
  }

  Future<void> acceptCall() async {
    if (isClosed) return;
    print("📞 Chấp nhận cuộc gọi...");

    final state = this.state;
    if (state is! CallStateLoading) {
      print("⚠️ Không thể chấp nhận cuộc gọi ở trạng thái hiện tại!");
      return;
    }

    // Đảm bảo PeerConnection được khởi tạo
    if (_peerConnection == null ||
        _peerConnection!.signalingState ==
            RTCSignalingState.RTCSignalingStateClosed) {
      print("🔄 PeerConnection bị đóng, đang khởi tạo lại...");
      await _createPeerConnection();
    }

    try {
      // Kiểm tra trạng thái trước khi rollback
      if (_peerConnection!.signalingState !=
          RTCSignalingState.RTCSignalingStateStable) {
        print("⚠️ PeerConnection không stable, rollback...");
        await _peerConnection!.setLocalDescription(
            RTCSessionDescription("", "rollback")).catchError((e) {
          print("⚠️ Rollback thất bại: $e");
        });
      }


      // Chờ PeerConnection về trạng thái stable
      await _waitForStableConnection();

      // Đặt Remote Description
      RTCSessionDescription remoteDesc =
          RTCSessionDescription(state.signal_sdp, state.signal_type);
      await _peerConnection!.setRemoteDescription(remoteDesc);
      print("✅ Đã đặt Remote Description thành công!");

      // Tạo Answer và đặt Local Description
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      print("✅ Đã tạo và đặt Local Description!");

      // Gửi Answer đến server
      final socket = await _socketService.socket;
      socket.emit("answerCall", {
        "from": await GlobalStorage.getUserId(),
        "to": state.user.id,
        "signal": answer.toMap(),
      });

      if (!isClosed) {
        emit(CallStateSuccess(user: state.user));
      }
    } catch (e) {
      print("❌ Lỗi khi chấp nhận cuộc gọi: $e");
    }
  }

  Future<void> _waitForStableConnection() async {
    while (_peerConnection?.signalingState !=
        RTCSignalingState.RTCSignalingStateStable) {
      print("⏳ Chờ PeerConnection về trạng thái stable...");
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    _peerConnection?.dispose();
    emit(CallStateInitial());
  }
}
