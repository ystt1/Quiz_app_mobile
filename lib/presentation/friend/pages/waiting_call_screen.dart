import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/call/call_cubit.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class OutgoingCallScreen extends StatelessWidget {
  final SimpleUserEntity user;

  const OutgoingCallScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Đang gọi ${user.email}...",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 40),
          FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(Icons.call_end, color: Colors.white),
            onPressed: () {
              context.read<CallCubit>().dispose();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
