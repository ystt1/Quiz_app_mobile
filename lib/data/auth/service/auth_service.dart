import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/core/constant/url.dart';
import 'package:quiz_app/data/auth/models/login_payload.dart';
import 'package:quiz_app/data/auth/models/register_payload.dart';
import 'package:quiz_app/data/auth/models/token_get_model.dart';

abstract class AuthService {
  Future<Either> login(LoginPayLoad user);
  Future<Either> register(RegisterPayload user);
}

class AuthServiceImp extends AuthService {
  @override
  Future<Either> login(LoginPayLoad user) async {
    try {
      final uri = Uri.parse('http://$url:5000/api/user/log-in');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user.toMap()));
      if(response.statusCode==200)
        {
          var result= TokenGetModel.fromMap(jsonDecode(response.body));
          return Right(result);
        }
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> register(RegisterPayload user) async {
    try {
      final uri = Uri.parse('http://$url:5000/api/user');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user.toMap()));
      if(response.statusCode==200)
      {
        return Right(true);
      };
      return Left((jsonDecode(response.body)["message"]["message"])??"Some thing went wrong");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
