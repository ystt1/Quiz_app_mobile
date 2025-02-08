import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:quiz_app/core/constant/url.dart';
import 'package:quiz_app/data/api_service.dart';
import 'package:quiz_app/data/conversation/models/message_model.dart';
import 'package:quiz_app/service_locator.dart';

import '../models/conversation_model.dart';

abstract class ConversationService {
  Future<Either> getListConversation();
  Future<Either> getMessage(String id);
}

class ConversationServiceImp extends ConversationService {
  @override
  Future<Either> getListConversation() async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get(
        'http://$url:5000/api/conversation',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final results =
        data.map((result) => ConversationModel.fromMap(result)).toList();
        return Right(results);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getMessage(String id) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get(
        'http://$url:5000/api/message/$id',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final results =
        data.map((result) => MessageModel.fromMap(result)).toList();
        return Right(results);
      }
      ;
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Some thing went wrong");
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }
}