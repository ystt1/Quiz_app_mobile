import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/token_state.dart';
import 'package:quiz_app/core/global_storage.dart';
import 'package:quiz_app/data/auth/models/login_payload.dart';
import 'package:quiz_app/data/user/service/user_service.dart';
import 'package:quiz_app/domain/auth/usecase/login_usecase.dart';
import 'package:quiz_app/domain/user/entity/user_entity.dart';
import 'package:quiz_app/domain/user/usecase/get_user_detail_usecase.dart';

import '../../data/api_service.dart';
import '../../service_locator.dart';

class TokenCubit extends Cubit<TokenState> {
  final TokenService _tokenService;

  TokenCubit(this._tokenService) : super(TokenInitial());

  Future<void> initialize() async {
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken != null) {
      final response = await sl<GetUserDetailUseCase>().call(params: "");
      response.fold((error) async {
        await _tokenService.clearTokens();
        emit(TokenInitial());
      }, (data) async {
        await GlobalStorage.saveUserId((data as UserEntity).id);
        emit(TokenSuccess());
      });
    } else {
      emit(TokenInitial());
    }
  }


  Future<void> login(LoginPayLoad loginPayload) async {
    try {
      final response = await sl<LoginUseCase>().call(params: loginPayload);
      response.fold((error) {
        emit(TokenFailure(error: error));
      }, (data) async {
        await _tokenService.saveTokens(data.accessToken, data.refreshToken);
        initialize();

      });
    }catch (e) {

      emit(TokenFailure(error: e.toString()));
    }
  }

  Future<void> checkToken()async
  {
    final response = await sl<GetUserDetailUseCase>().call(params:"" );
    response.fold((error) {
      emit(TokenFailure(error: error));
    }, (data) async {

    });
  }

  Future<void> logout() async {
    await _tokenService.clearTokens();
    emit(TokenInitial());
  }

  Future<void> handleRefreshTokenFailure() async {
    await logout();
  }



}
