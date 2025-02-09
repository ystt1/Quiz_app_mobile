import 'package:flutter/material.dart';
import 'package:quiz_app/common/helper/app_helper.dart';
import 'package:quiz_app/domain/quiz/entity/result_entity.dart';

import '../../../common/widgets/build_base_64_image.dart';

class ResultCard extends StatelessWidget {
  final ResultEntity result;
  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          width: 60,
          height: 60,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Base64ImageWidget(
                base64String: result.quizId.image,
              )),
        ),
        title: Text(
          result.quizId.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score: ${result.score}',
                style: const TextStyle(
                    color: Colors.black54)),
            Text(
                'Completion Time: ${AppHelper.formatDuration(result.completeTime)}',
                style: const TextStyle(
                    color: Colors.black54)),
            Text('Attempts: ${result.attemptTime}',
                style: const TextStyle(
                    color: Colors.black54)),
            Text(
                'Date: ${AppHelper.dateFormat(result.createdAt)}',
                style: const TextStyle(
                    color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
