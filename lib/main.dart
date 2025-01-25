import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/token_state.dart';
import 'package:quiz_app/core/constant/app_theme.dart';
import 'package:quiz_app/presentation/auth/pages/login_page.dart';
import 'package:quiz_app/presentation/home/pages/home_page.dart';
import 'package:quiz_app/service_locator.dart';

import 'common/bloc/token_cubit.dart';
import 'data/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  final tokenService = TokenService();

  runApp(
    BlocProvider(
      create: (_) => TokenCubit(tokenService)..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: appTheme,
        home: BlocBuilder<TokenCubit, TokenState>(builder: (context, state) {
          // return isLoggedIn ? const HomePage() : const LoginPage();\
          if(state is TokenInitial)
            {
              return const LoginPage();
            }
          if(state is TokenFailure)
            {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              });

              return const LoginPage();
            }
          if(state is TokenSuccess)
            {
              return const HomePage();
            }
          return const LoginPage();
        }));
  }
}
