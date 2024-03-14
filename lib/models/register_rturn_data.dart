class RegisterReturnData {
  final String messgae;
  final String access_token;

  const RegisterReturnData({
    required this.messgae,
    required this.access_token,
  });

  factory RegisterReturnData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      "messgae": String messgae,
      "access_token": String access_token,
      } =>
          RegisterReturnData(
            messgae: messgae,
            access_token: access_token,
          ),
      _ => throw const FormatException('format error'),
    };
  }
}