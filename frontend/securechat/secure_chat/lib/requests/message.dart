import 'dart:convert';

import 'package:secure_chat/requests/base.dart';
import 'package:http/http.dart' as http;

class RequestsMessage extends RequestsBase {
  Future<void> sendMessage(String message, String conversationUuid) async {
    final String url = buildUrl("messages");
    final body = {
      "message": {"content": message, "conversation_uuid": conversationUuid}
    };
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: await buildHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send message");
    }
  }
}
