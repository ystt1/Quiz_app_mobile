class ChangeProfilePayLoadModel{
  final String? avatar;
  final String? oldPassword;
  final String? password;

  ChangeProfilePayLoadModel({required this.avatar, required this.oldPassword, required this.password});

  Map<String, dynamic> toMap() {
    if(avatar != null ) {
      return {
        'avatar': this.avatar,
      };
    }else{
      return {
        'oldPassword': this.oldPassword,
        'password': this.password,
      };
    }
  }

  factory ChangeProfilePayLoadModel.fromMap(Map<String, dynamic> map) {
    return ChangeProfilePayLoadModel(
      avatar: map['avatar'] as String,
      oldPassword: map['oldPassword'] as String,
      password: map['password'] as String,
    );
  }
}