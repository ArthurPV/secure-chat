import 'package:secure_chat/utils/sercure_store.dart';

class RequestsBase {
  // TODO: Maybe improve by getting the baseUrl from the .env file
  final baseUrl = "http://localhost:3000";
  String? _sessionToken;

  String buildUrl(String endpoint) {
    return "$baseUrl/$endpoint";
  }

  Future<String?> getSessionToken() async {
    _sessionToken ??= await SecureStore.getSessionToken();

    return _sessionToken;
  }

  Future<void> setSessionToken(String token) async {
    _sessionToken = token;
    await SecureStore.saveSessionToken(token);
  }

  Future<Map<String, String>> buildHeaders() async {
    String sessionToken = (await getSessionToken()) ?? "";

    return <String, String>{
      "Content-Type": "application/json",
      "Authorization": "Bearer $sessionToken",
    };
  }
}
