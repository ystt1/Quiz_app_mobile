import 'package:dartz/dartz.dart';
import 'package:quiz_app/data/auth/models/login_payload.dart';
import 'package:quiz_app/data/auth/models/register_payload.dart';

abstract class AuthRepository{
  Future<Either> login(LoginPayLoad loginPayload);
  Future<Either> register(RegisterPayload registerPayload);
}