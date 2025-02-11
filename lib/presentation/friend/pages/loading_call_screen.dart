import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/call/call_cubit.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class IncomingCallScreen extends StatelessWidget {
  final SimpleUserEntity user;

  const IncomingCallScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${user.email} đang gọi...",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 20),
          GestureDetector(child: Icon(Icons.phone_in_talk, size: 80, color: Colors.green)),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: "end-call",
                backgroundColor: Colors.red,
                child: Icon(Icons.call_end, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Builder(
                builder: (context) {
                  return FloatingActionButton(
                    heroTag: 'accept-call',
                    backgroundColor: Colors.green,
                    child: Icon(Icons.call, color: Colors.white),
                    onPressed: () {
                      BlocProvider.of<CallCubit>(context, listen: false).acceptCall();
                    },
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
