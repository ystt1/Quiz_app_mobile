import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/token_cubit.dart';
import 'package:quiz_app/core/constant/app_color.dart';
import 'package:quiz_app/data/auth/models/login_payload.dart';
import 'package:quiz_app/presentation/auth/pages/sign_up_page.dart';
import 'package:quiz_app/presentation/home/pages/home_page.dart';

import '../../../common/bloc/token_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => ButtonStateCubit(),
        child: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titlePage(),
                //const Spacer(),
                const SizedBox(height: 200),
                _emailText(),
                const SizedBox(height: 8),
                _emailField(),
                const SizedBox(height: 16),
                _passwordText(),
                const SizedBox(height: 8),
                _passwordField(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    _forgotPasswordText(),
                  ],
                ),
                const SizedBox(height: 24),
                _loginButton(context),
                const SizedBox(height: 24),
                Center(child: _signUpText()),
                const SizedBox(height: 32),
                const Divider(color: AppColors.primaryColor),
                const SizedBox(height: 16),
                _orLoginWithText(),
                const SizedBox(height: 16),
                _listIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titlePage() {
    return const Center(
      child: Text(
        'Welcome Back!',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _emailText() {
    return const Text(
      'Email',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _userName,
      decoration: InputDecoration(
        hintText: "Enter your user name",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _passwordText() {
    return const Text(
      'Password',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _password,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Enter your password",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Builder(builder: (context) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () => {
            context.read<TokenCubit>().login(LoginPayLoad(
            username: _userName.text, password: _password.text)),
            if(context.read<TokenCubit>().state is TokenSuccess)
        {
            setState(() {

            })
      }
      },
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 18),
        ),
      ),);
    });
  }

  Widget _forgotPasswordText() {
    return GestureDetector(
      onTap: () {},
      child: const Text(
        "Forgot Password?",
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _signUpText() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: "Sign Up",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orLoginWithText() {
    return const Center(
      child: Text(
        "Or login with",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _listIcon() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          FontAwesomeIcons.instagram,
          size: 35,
          color: Colors.pink,
        ),
        Icon(
          FontAwesomeIcons.facebook,
          size: 35,
          color: Colors.blue,
        ),
        Icon(
          FontAwesomeIcons.google,
          size: 35,
          color: Colors.red,
        ),
      ],
    );
  }
}
