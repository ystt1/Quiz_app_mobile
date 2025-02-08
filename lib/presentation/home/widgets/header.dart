import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_cubit.dart';
import 'package:quiz_app/common/bloc/user/get_user_detail_state.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/common/widgets/get_something_wrong.dart';
import 'package:quiz_app/presentation/profile/page/profile_page.dart';
import 'package:quiz_app/presentation/search/pages/search_page.dart';

import '../../../core/global_storage.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserDetailCubit, GetUserDetailState>(
      builder: (BuildContext context, state) {
        if (state is GetUserDetailLoading) {
          return GetLoading();
        }
        if (state is GetUserDetailFailure) {
          return GetFailure(name: state.error);
        }
        if (state is GetUserDetailSuccess) {
          GlobalStorage.saveUserId(state.user.id);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(
                 child: Text(
                  "Welcome ${state.user.userName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                               ),
               ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child:  CircleAvatar(
                     radius: 20,
                     child: ClipRRect(borderRadius: BorderRadius.circular(60),
                          child: Base64ImageWidget(base64String: state.user.avatar,)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        }
        return GetSomethingWrong();
      },
    );
  }
}
