import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:secure_chat/requests/base.dart';

class RequestsRegistration extends RequestsBase {
  Future<void> signUp(String email, String password, String username,
      String phoneNumber, String publicKey, String privateKey) async {
    final String url = buildUrl("auth/sign_up");
    final body = {
      "user": {
        "email": email,
        "password": password,
        "username": username,
        "phone_number": phoneNumber,
        "public_key": publicKey,
        "private_key": privateKey
      }
    };
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: await buildHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 204) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String token = data["token"];
      await setSessionToken(token);
    } else {
      throw Exception("Failed to sign up");
    }
  }
}
