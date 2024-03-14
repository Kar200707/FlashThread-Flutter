class AiData {
  final String aiGeneratedMessage;

  const AiData({
    required this.aiGeneratedMessage,
  });

  factory AiData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "aiGeneratedMessage": String aiGeneratedMessage
      } =>
          AiData(
            aiGeneratedMessage: aiGeneratedMessage,
          ),
      _ => throw const FormatException('format error'),
    };
  }
}