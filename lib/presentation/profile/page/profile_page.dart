import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/bloc/profile/get_profile_cubit.dart';
import 'package:quiz_app/common/bloc/profile/get_profile_state.dart';
import 'package:quiz_app/common/bloc/token_cubit.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/data/user/model/change_profile_payload_model.dart';
import 'package:quiz_app/domain/user/usecase/change_profile_usecase.dart';
import 'package:quiz_app/domain/user/usecase/get_user_detail_usecase.dart';

import '../../../common/helper/get_img_string.dart';
import '../../../common/widgets/profile_avatar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _pickImage(BuildContext context) async {
    String? newBase64 = await getImgString();
    if (newBase64 != null) {
      context.read<GetProfileCubit>().onChangeAvatar(newBase64);
    }
  }

  void _saveAvatar(BuildContext context, String flag) {
    context.read<ButtonStateCubit>().execute(
        usecase: ChangeProfileUseCase(),
        params: ChangeProfilePayLoadModel(
            avatar: flag, oldPassword: null, password: null));
  }

  void _cancelAvatarChange(BuildContext context) {
    context.read<GetProfileCubit>().cancelAvatarChange();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => GetProfileCubit()
              ..onGet(useCase: GetUserDetailUseCase(), params: '')),
        BlocProvider(create: (_) => ButtonStateCubit())
      ],
      child: BlocListener<ButtonStateCubit,ButtonState>(
        listener: (BuildContext context, btnState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          print(btnState);
          if(btnState is ButtonLoadingState)
            {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GetLoading()));
            }
          if(btnState is ButtonFailureState)
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetFailure(name: btnState.errorMessage)));
          }
          if(btnState is ButtonSuccessState)
          {
           context.read<GetProfileCubit>().onChangeAvatarSuccess();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<GetProfileCubit, GetProfileState>(
              builder: (BuildContext context, GetProfileState state) {
                if (state is GetProfileLoading) return const GetLoading();
                if (state is GetProfileFailure)
                  return GetFailure(name: state.error);
                if (state is GetProfileSuccess) {

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImage(context);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            profileAvatar(state.flagAvatar),
                            const Positioned(
                              top: 20,
                              right: 20,
                              child: Icon(Icons.camera_alt,
                                  color: Colors.white70, size: 30),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      state.user.avatar != state.flagAvatar
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Builder(
                                    builder: (context) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          _saveAvatar(context, state.flagAvatar);
                                        },
                                        child: const Text("Save"),
                                      );
                                    }
                                  ),
                                ),
                                const SizedBox(width: 10),
                                OutlinedButton(
                                  onPressed: () => _cancelAvatarChange(context),
                                  child: const Text("Cancel"),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      Text(state.user.email,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      QrImageView(data: state.user.id, size: 150),
                      ProfileStat(title: "Friends", value: state.user.friendCount.toString()),
                      ProfileStat(title: "Points", value: state.user.totalScore.toString()),
                      ProfileStat(title: "Quizzes", value: state.user.quizCount.toString()),
                      ProfileStat(title: "Questions", value: state.user.questionCount.toString()),
                      ProfileStat(
                          title: "Date join",
                          value: AppHelper.dateFormat(state.user.createdAt)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Change Password"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context.read<TokenCubit>().logout(),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 5),
                            Text("Log out")
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const GetSomethingWrong();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  ProfileStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
