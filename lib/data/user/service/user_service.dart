import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/core/constant/url.dart';
import 'package:quiz_app/data/api_service.dart';
import 'package:quiz_app/data/user/model/change_profile_payload_model.dart';
import 'package:quiz_app/data/user/model/user_model.dart';
import 'package:quiz_app/service_locator.dart';

import '../model/simple_user_model.dart';

abstract class UserService {
  Future<Either> getUserDetail(String userId);

  Future<Either> changeProfile(ChangeProfilePayLoadModel profile);
  
  Future<Either> addFriend(String id);

  Future<Either> cancelFriendRequest(String id);

  Future<Either> acceptFriendRequest(String id);

  Future<Either> deleteFriendRequest(String id);

  Future<Either> getListFriend(String id);

  Future<Either> getListFriendRequest();
}

class UserServiceImp extends UserService {
  @override
  Future<Either> getUserDetail(String userId) async {
    try {
      final apiService = sl<ApiService>();
      var response;
      if (userId != '') {
        response = await apiService.get('$url/user/$userId');
      } else {
        response = await apiService.get('$url/user/my-profile');
      }
      if (response.statusCode == 200) {
        return Right(UserModel.fromMap(jsonDecode(response.body)["data"]));
      }
      return Left((jsonDecode(response.body)["message"]["message"]) ??
          "Api went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> changeProfile(ChangeProfilePayLoadModel profile) async {
    try {

      final apiService = sl<ApiService>();
      final response = await apiService.put(
          '$url/user/change-profile', profile.toMap());

      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left((jsonDecode(response.body)["message"]) ?? "Api went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addFriend(String id) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.post(
          '$url/friend',{'recipientId':id});
      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left((jsonDecode(response.body)["message"]) ?? "Api went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> cancelFriendRequest(String id) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.post(
          '$url/friend/cancel',{'friendId':id});
      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left((jsonDecode(response.body)["message"]) ?? "Api went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> acceptFriendRequest(String id) async {
    try {

      final apiService = sl<ApiService>();
      final response = await apiService.post(
          '$url/friend/accept',{'requesterId':id});
      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left((jsonDecode(response.body)["message"]) ?? "Api went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteFriendRequest(String id) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.delete(
          '$url/friend/cancel',{'friendId':id});
      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left((jsonDecode(response.body)["message"]) ?? "Api went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getListFriend(String id) async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get('$url/friend/friends${id!=""?"?idUser=$id":""}',);

      if(response.statusCode==200)
      {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final results = data.map((result) => SimpleUserModel.fromMap(result['user'])).toList();
        return Right(results);
      };
      return Left((jsonDecode(response.body)["message"])??"Some thing went wrong");
    } catch (e) {

      return Left(e.toString());
    }

  }

  @override
  Future<Either> getListFriendRequest() async {
    try {

      final apiService = sl<ApiService>();
      final response = await apiService.get('$url/friend/request',);

      if(response.statusCode==200)
      {
        final List<dynamic> data = jsonDecode(response.body)["data"];
        final results = data.map((result) => SimpleUserModel.fromMap(result["requester"])).toList();
        return Right(results);
      };
      return Left((jsonDecode(response.body)["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }


}
