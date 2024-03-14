class AiMessage {
  String message;
  String sender;

  AiMessage({
    required this.message,
    required this.sender,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
    };
  }
}