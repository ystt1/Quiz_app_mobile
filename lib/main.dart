import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/token_state.dart';
import 'package:quiz_app/core/constant/app_theme.dart';
import 'package:quiz_app/presentation/auth/pages/login_page.dart';
import 'package:quiz_app/presentation/home/pages/home_page.dart';
import 'package:quiz_app/service_locator.dart';
import 'common/bloc/token_cubit.dart';
import 'data/api_service.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }


  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (globalNavigatorKey.currentState?.canPop() ?? false) {
      globalNavigatorKey.currentState?.pop();
      return true;
    } else {
      if (globalNavigatorKey.currentContext != null) {
        _showExitDialog(globalNavigatorKey.currentContext!);
      }
      return true;
    }
  }





  void _showExitDialog(BuildContext? context) {
    if (context == null) return; // Tránh lỗi khi context null

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thoát ứng dụng?"),
        content: const Text("Bạn có chắc muốn thoát ứng dụng không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Đóng hộp thoại
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 200), () {
                SystemNavigator.pop(); // Thoát ứng dụng
              });
            },
            child: const Text("Thoát"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      title: 'Flutter Demo',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<TokenCubit, TokenState>(
        builder: (context, state) {
          if (state is TokenInitial) {
            return const LoginPage();
          }
          if (state is TokenFailure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            });
            return const LoginPage();
          }
          if (state is TokenSuccess) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
