import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/user/model/change_profile_payload_model.dart';
import 'package:quiz_app/data/user/model/simple_user_model.dart';
import 'package:quiz_app/data/user/model/user_model.dart';
import 'package:quiz_app/data/user/service/user_service.dart';
import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';
import 'package:quiz_app/domain/user/repository/user_repository.dart';
import 'package:quiz_app/service_locator.dart';

class UserRepositoryImp extends UserRepository {
  @override
  Future<Either> getUserDetail(String id) async {
    try {
      final returnedData = await sl<UserService>().getUserDetail(id);
      return returnedData.fold(
            (error) => Left(error),
            (data) => Right((data as UserModel).toEntity()),
      );
    }
    catch (e)
    {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> changeProfile(ChangeProfilePayLoadModel profile) async {
    return await sl<UserService>().changeProfile(profile);
  }

  @override
  Future<Either> addFriend(String idUser) async {
    return await sl<UserService>().addFriend(idUser);
  }

  @override
  Future<Either> cancelFriendRequest(String idUser) async {
    return await sl<UserService>().cancelFriendRequest(idUser);
  }

  @override
  Future<Either> acceptFriendRequest(String idUser) async {
    return await sl<UserService>().acceptFriendRequest(idUser);
  }

  @override
  Future<Either> deleteFriendRequest(String id) async {
    return await sl<UserService>().deleteFriendRequest(id);
  }

  @override
  Future<Either> getFriend(String id) async {
    try {
      final response = await sl<UserService>().getListFriend(id);
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<SimpleUserModel>)
            .map((SimpleUserModel user) => user.toEntity())
            .toList();
        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getFriendRequest() async {
    try {
      final response = await sl<UserService>().getListFriendRequest();
      return response.fold((error) => Left(error), (data) {
        final entity = (data as List<SimpleUserModel>)
            .map((SimpleUserModel user) => user.toEntity())
            .toList();
        return Right(entity);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }
}
