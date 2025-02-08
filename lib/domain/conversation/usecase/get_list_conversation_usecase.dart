import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/usecase.dart';
import 'package:quiz_app/data/conversation/service/conversation_service.dart';
import 'package:quiz_app/domain/conversation/repository/conversation_repository.dart';
import 'package:quiz_app/service_locator.dart';

class GetListConversationUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<ConversationRepository>().getListConversation();
  }

}