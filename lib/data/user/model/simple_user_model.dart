import 'package:quiz_app/domain/user/entity/sample_user_entity.dart';

class SimpleUserModel{
  final String id;
  final String email;
  final String avatar;

  SimpleUserModel({required this.id, required this.email, required this.avatar});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'avatar': this.avatar,
    };
  }

  factory SimpleUserModel.fromMap(Map<String, dynamic> map) {
    return SimpleUserModel(
      id: map['_id'] ?? map['id'],
      email: map['email'] as String,
      avatar: map['avatar'] ?? "",
    );
  }
}

extension SimpleUserModelToEntity on SimpleUserModel
{
  SimpleUserEntity toEntity()
  {
    return SimpleUserEntity(id: id, email: email, avatar: avatar);
  }
}