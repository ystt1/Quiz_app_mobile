import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/core/constant/app_color.dart';
import 'package:quiz_app/data/auth/models/register_payload.dart';
import 'package:quiz_app/domain/auth/usecase/register_usecase.dart';
import 'package:quiz_app/presentation/auth/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();

  void onSignUp(BuildContext context) {
    if (_userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _rePasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(
        child: Text("Pls Enter All Field"),
      )));
    } else if (_passwordController.text != _rePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(
        child: Text("Re-password wrong"),
      )));
    } else {
      context.read<ButtonStateCubit>().execute(
          usecase: RegisterUseCase(),
          params: RegisterPayload(
              useName: _userNameController.text,
              password: _passwordController.text,
              gmail: _emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (BuildContext context, state) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (state is ButtonLoadingState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: GetLoading()));
            }
            if (state is ButtonFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: GetFailure(name: state.errorMessage)));
            }
            if (state is ButtonSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Register success")));
              Navigator.of(context).pop();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titlePage(),
                      //const Expanded(child: SizedBox()),
                      _emailText(),
                      const SizedBox(height: 8),
                      _emailField(),
                      const SizedBox(height: 16),
                      _fullNameText(),
                      const SizedBox(height: 8),
                      _fullNameField(),
                      const SizedBox(height: 16),
                      _passwordText(),
                      const SizedBox(height: 8),
                      _passwordField(),
                      const SizedBox(height: 16),
                      _rePasswordText(),
                      const SizedBox(height: 8),
                      _rePasswordField(),
                      const SizedBox(height: 24),
                      _signUpButton(),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _titlePage() {
    return const Center(
      child: Text(
        'Hi New Friend!',
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
      'UserName',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _userNameController,
      decoration: const InputDecoration(
        hintText: "Enter your userName",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _fullNameText() {
    return const Text(
      'Email',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _fullNameField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        hintText: "Enter email address",
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
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Enter your password",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _rePasswordText() {
    return const Text(
      'Re-Password',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _rePasswordField() {
    return TextField(
      controller: _rePasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Enter your password again",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _signUpButton() {
    return Builder(builder: (context) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => {onSignUp(context)},
          child: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    });
  }

  Widget _signUpText() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "Already have account? ",
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: "Login",
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
