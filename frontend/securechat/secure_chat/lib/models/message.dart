class ModelMessage {
  DateTime createdAt;
  DateTime updatedAt;
  String content;
  String userUuid;

  ModelMessage({
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.userUuid,
  });

  factory ModelMessage.fromJson(Map<String, dynamic> json) {
    return ModelMessage(
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      content: json["content"],
      userUuid: json["user_uuid"],
    );
  }
}
