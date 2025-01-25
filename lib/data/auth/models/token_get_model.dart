import 'package:quiz_app/domain/auth/entity/token_get_entity.dart';

class TokenGetModel {
  final String accessToken;
  final String refreshToken;

  TokenGetModel({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toMap() {
    return {
      'accessToken': this.accessToken,
      'refreshToken': this.refreshToken,
    };
  }

  factory TokenGetModel.fromMap(Map<String, dynamic> map) {
    return TokenGetModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['access_token'] as String,
    );
  }
}

extension TokenGetModelToEntity on TokenGetModel {
  TokenGetEntity toEntity() {
    return TokenGetEntity(accessToken: accessToken, refreshToken: refreshToken);
  }
}
