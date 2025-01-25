import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/token_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: IconButton(
      icon: Icon(Icons.logout),
      onPressed: () => context.read<TokenCubit>().logout(),
    ),);
  }
}
