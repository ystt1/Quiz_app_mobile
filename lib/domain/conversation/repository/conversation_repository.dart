import 'package:dartz/dartz.dart';

abstract class ConversationRepository{
  Future<Either> getListConversation();
  Future<Either> getMessage(String id);
}