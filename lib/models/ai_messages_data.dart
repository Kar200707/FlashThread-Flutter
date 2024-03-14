class AiMessagesData {
  final String userId;
  final List<Map<String, dynamic>> messages;

  const AiMessagesData({
    required this.userId,
    required this.messages,
  });

  factory AiMessagesData.fromJson(Map<String, dynamic> json) {
    final userId = json['userId'];
    final List<Map<String, dynamic>> messages = List<Map<String, dynamic>>.from(json['messages']);

    return AiMessagesData(
      userId: userId,
      messages: messages,
    );
  }
}
