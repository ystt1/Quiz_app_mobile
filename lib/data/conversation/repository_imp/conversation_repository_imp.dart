import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/conversation/models/conversation_model.dart';
import 'package:quiz_app/data/conversation/service/conversation_service.dart';
import 'package:quiz_app/domain/conversation/repository/conversation_repository.dart';
import 'package:quiz_app/service_locator.dart';

class ConversationRepositoryImp extends ConversationRepository {
  @override
  Future<Either> getListConversation() async {
    try {
      final response = await sl<ConversationService>().getListConversation();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<ConversationModel>)
            .map((ConversationModel result) => result.toEntity())
            .toList();
        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getMessage(String id) async {
    return await sl<ConversationService>().getMessage(id);
  }

}