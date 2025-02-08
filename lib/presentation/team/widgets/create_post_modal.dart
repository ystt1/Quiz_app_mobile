import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/helper/get_img_string.dart';
import 'package:quiz_app/common/widgets/build_base_64_image.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/data/post/models/post_payload_model.dart';

import 'package:quiz_app/domain/post/usecase/add_post_usecase.dart';
import 'package:quiz_app/domain/team/entity/team_entity.dart';

import '../../../domain/post/usecase/add_post_usecase.dart';

class CreatePostModal extends StatefulWidget {
  final TeamEntity team;
  final VoidCallback onRefresh;

  const CreatePostModal({super.key, required this.team, required this.onRefresh});

  @override
  _CreatePostModalState createState() => _CreatePostModalState();
}

class _CreatePostModalState extends State<CreatePostModal> {
  late String? _selectedImage='';
  final TextEditingController _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit,ButtonState>(
        listener: (BuildContext context, state) {
          if(state is ButtonLoadingState)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetLoading()));
            }
          if(state is ButtonFailureState)
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetFailure(name: state.errorMessage)));
          }
          if(state is ButtonSuccessState)
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetFailure(name: "Sucess")));
            widget.onRefresh.call();
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Post',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _postController,
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                if (_selectedImage != ''&&_selectedImage !=null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),

                        ),
                        child: Base64ImageWidget(base64String: _selectedImage,),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = "";
                          });
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        String? image=await getImgString();
                        if (image != null) {
                          setState(() {
                            _selectedImage=image;
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                    ),
                    const Spacer(),
                    Builder(
                      builder: (context) {
                        return Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<ButtonStateCubit>().execute(usecase: AddPostUseCase(),params: PostPayloadModel(content:_postController.text,team: widget.team.id,image: _selectedImage));

                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Post'),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
