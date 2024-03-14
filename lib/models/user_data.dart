class UserData {
  final bool isMailVerify;
  final String email;
  final String name;
  final String l_name;
  final String avatar;
  final String bio;
  final String id;

  const UserData({
    required this.isMailVerify,
    required this.email,
    required this.name,
    required this.l_name,
    required this.avatar,
    required this.bio,
    required this.id,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      "isMailVerify": bool isMailVerify,
      "email": String email,
      "name": String name,
      "l_name": String l_name,
      "avatar": String avatar,
      "bio": String bio,
      "id": String id,
      } =>
          UserData(
            isMailVerify: isMailVerify,
            email: email,
            name: name,
            l_name: l_name,
            avatar: avatar,
            bio: bio,
            id: id,
          ),
      _ => throw const FormatException('format error'),
    };
  }
}