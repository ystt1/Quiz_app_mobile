import 'package:flutter/material.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:quiz_app/presentation/team/pages/user_detail_modal.dart';

void onClickUser(BuildContext context,String userId,String? teamId)
{
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (innerContext) => UserModalPage( userId: userId,idTeam: teamId,)
  );
}