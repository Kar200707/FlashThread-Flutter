class LoginReturnData {
  final String message;
  final String access_token;

  const LoginReturnData({
    required this.message,
    required this.access_token,
  });

  factory LoginReturnData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      "message": String message,
      "access_token": String access_token,
      } =>
          LoginReturnData(
            message: message,
            access_token: access_token,
          ),
      _ => throw const FormatException('format error'),
    };
  }
}