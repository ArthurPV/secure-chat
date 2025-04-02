import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:secure_chat/requests/base.dart';
import 'package:secure_chat/utils/sercure_store.dart';

class RequestsAuthorization extends RequestsBase {
  Future<bool> signIn(String email, String password) async {
    final String url = buildUrl("auth/sign_in");
    // TODO: Maybe secure the password
    final body = {
      "user": {"email": email, "password": password}
    };
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: await buildHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String token = data["token"];
      await setSessionToken(token);

      return true;
    }

    return false;
  }

  Future<void> signOut() async {
    final String url = buildUrl("auth/sign_out");
    final http.Response response = await http.delete(
      Uri.parse(url),
      headers: await buildHeaders(),
    );

    if (response.statusCode == 204) {
      await SecureStore.clearAll();
    } else {
      throw Exception("Failed to sign out");
    }
  }

  Future<bool> isAuthenticated() async {
    final String? token = await getSessionToken();
    return token != null && token.isNotEmpty;
  }
}
