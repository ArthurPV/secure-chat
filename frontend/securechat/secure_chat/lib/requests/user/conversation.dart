import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:secure_chat/models/user/conversation.dart';
import 'package:secure_chat/requests/base.dart';

class RequestsUserConversation extends RequestsBase {
  Future<void> create(String name, List<String> participants, String publicKey,
      String privateKey) async {
    final String url = buildUrl("user_conversations");
    final body = {
      "user_conversation": {
        "public_key": publicKey,
        "private_key": privateKey,
        "participants": participants
      }
    };
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: await buildHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode != 204) {
      throw Exception("Failed to create conversation");
    }
  }

  Future<void> delete(String conversationUuid) async {
    final String url = buildUrl("user_conversations/$conversationUuid");
    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: await buildHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception("Failed to delete conversation");
    }
  }

  Future<List<ModelUserConversation>> getAll() async {
    final String url = buildUrl("user_conversations");
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: await buildHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return data['user_conversations']
          .map<ModelUserConversation>(
              (json) => ModelUserConversation.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to get user conversation");
    }
  }
}
