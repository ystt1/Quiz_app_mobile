import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/user/model/change_profile_payload_model.dart';

abstract class UserRepository{
  Future<Either> getUserDetail(String id);
  Future<Either> changeProfile(ChangeProfilePayLoadModel profile);
  Future<Either> addFriend(String idUser);
  Future<Either> cancelFriendRequest(String idUser);
  Future<Either> acceptFriendRequest(String idUser);
  Future<Either> deleteFriendRequest(String id);
  Future<Either> getFriend(String id);
  Future<Either> getFriendRequest();
}