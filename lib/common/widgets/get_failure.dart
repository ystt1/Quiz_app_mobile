import 'package:flutter/material.dart';

class GetFailure extends StatelessWidget {
  final String name;
  const GetFailure({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(name),);
  }
}
