class FullUserData {
  final bool isMailVerify;
  final String email;
  final String name;
  final String l_name;
  final String avatar;
  final String bio;
  final String id;
  final List<dynamic> devices;
  final String device;
  final bool isOnline;
  final String mailVerifyCode;
  final dynamic last_connection;

  const FullUserData({
    required this.isMailVerify,
    required this.email,
    required this.name,
    required this.l_name,
    required this.avatar,
    required this.bio,
    required this.id,
    required this.device,
    required this.devices,
    required this.isOnline,
    required this.mailVerifyCode,
    required this.last_connection,
  });

  factory FullUserData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      "isMailVerify": bool isMailVerify,
      "email": String email,
      "name": String name,
      "l_name": String l_name,
      "avatar": String avatar,
      "bio": String bio,
      "id": String id,
      "devices": List<dynamic> devices,
      "device": String device,
      "isOnline": bool isOnline,
      "mailVerifyCode": String mailVerifyCode,
      "last_connection": dynamic last_connection
      } =>
          FullUserData(
            isMailVerify: isMailVerify,
            email: email,
            name: name,
            l_name: l_name,
            avatar: avatar,
            bio: bio,
            id: id,
            devices: devices,
            device: device,
            isOnline: isOnline,
            mailVerifyCode: mailVerifyCode,
            last_connection: last_connection
          ),
      _ => throw const FormatException('format error'),
    };
  }
}