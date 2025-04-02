import 'package:secure_chat/models/message.dart';

class ModelUserConversation {
  DateTime createdAt;
  DateTime updatedAt;
  List<ModelMessage> messages;

  ModelUserConversation({
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  factory ModelUserConversation.fromJson(Map<String, dynamic> json) {
    return ModelUserConversation(
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      messages: List<ModelMessage>.from(
          json["messages"].map((x) => ModelMessage.fromJson(x))),
    );
  }
}
