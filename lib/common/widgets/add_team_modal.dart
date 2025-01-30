import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app/common/bloc/button/button_state.dart';
import 'package:quiz_app/common/bloc/button/button_state_cubit.dart';
import 'package:quiz_app/common/helper/x_file_to_base64.dart';
import 'package:quiz_app/common/widgets/get_failure.dart';
import 'package:quiz_app/common/widgets/get_loading.dart';
import 'package:quiz_app/data/team/model/team_payload_model.dart';
import 'package:quiz_app/domain/team/usecase/add_team_usecase.dart';

class AddTeamModal extends StatefulWidget {
  @override
  _AddTeamPageState createState() => _AddTeamPageState();
}

class _AddTeamPageState extends State<AddTeamModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _maxMembersController = TextEditingController();
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: BlocProvider(
        create: (BuildContext context) =>ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit,ButtonState>(
          listener: (BuildContext context, state) {
            if(state is ButtonLoadingState)
              {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: GetLoading()));
              }
            if(state is ButtonFailureState)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: GetFailure(name: state.errorMessage)));
            }
            if(state is ButtonSuccessState)
            {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("success"),)));
            }
          },
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add Team",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Team Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'Team Code (6 digits)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _selectImage,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        image: _selectedImage != null
                            ? DecorationImage(
                          image: FileImage(File(_selectedImage!.path)),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: _selectedImage == null
                          ? const Center(child: Text('Select an Image'))
                          : const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _maxMembersController,
                    decoration: const InputDecoration(
                      labelText: 'Max Members',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  Builder(
                    builder: (context) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (){_addTeam(context);},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add New Team',
                            style: TextStyle(fontSize: 18),
                          ),
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
    );
  }

  void _selectImage() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Storage permission denied');
      return;
    }
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _addTeam(BuildContext context) async {
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    final maxMembers = _maxMembersController.text.trim();

    if (name.isEmpty ||
        code.isEmpty ||
        maxMembers.isEmpty ) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image.')),
      );
      return;
    }

    if (code.length != 6 || int.tryParse(code) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code must be a 6-digit number.')),
      );
      return;
    }

    final maxMembersInt = int.tryParse(maxMembers);
    if (maxMembersInt == null || maxMembersInt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Max Members must be a valid positive number.')),
      );
      return;
    }

    context.read<ButtonStateCubit>().execute(usecase: AddTeamUseCase(),params: TeamPayloadModel(name: name, image: "https://strategistsworld.com/wp-content/uploads/2021/01/img6.jpg", maxParticipant: maxMembersInt, code: code));
  }
}
