import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:secure_chat/models/user.dart';
import 'package:secure_chat/requests/base.dart';

class UserRequests extends RequestsBase {
  Future<ModelUser> get() async {
    final String url = buildUrl("users");
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: await buildHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ModelUser.fromJson(data);
    } else {
      throw Exception("Failed to get user");
    }
  }
}
