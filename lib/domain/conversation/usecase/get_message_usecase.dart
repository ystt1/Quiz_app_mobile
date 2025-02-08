import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/domain/conversation/repository/conversation_repository.dart';
import 'package:quiz_app/service_locator.dart';

class GetMessageUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<ConversationRepository>().getMessage(params!);
  }

}