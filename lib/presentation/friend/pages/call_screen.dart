import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:quiz_app/common/bloc/call/call_cubit.dart';
import 'package:quiz_app/common/bloc/call/call_state.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        final cubit = context.read<CallCubit>();

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: cubit.remoteRenderer.srcObject != null
                    ? RTCVideoView(cubit.remoteRenderer)
                    : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),

              Positioned(
                right: 20,
                bottom: 100,
                width: 120,
                height: 180,
                child: cubit.localRenderer.srcObject != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: RTCVideoView(
                    cubit.localRenderer,
                    mirror: true,
                  ),
                )
                    : const SizedBox(),
              ),

              /// Nút kết thúc cuộc gọi
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end, color: Colors.white),
                    onPressed: () {
                      cubit.dispose(); // Kết thúc cuộc gọi
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
