// TODO: Improve the organization of the code (in multiple files).
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/sercure_store.dart';

class Message { 
    DateTime createdAt;
    DateTime updatedAt;
    String content;
    String userUuid;

    Message({
        required this.createdAt,
        required this.updatedAt,
        required this.content,
        required this.userUuid,
    });

    factory Message.fromJson(Map<String, dynamic> json) {
        return Message(
            createdAt: DateTime.parse(json["created_at"]),
            updatedAt: DateTime.parse(json["updated_at"]),
            content: json["content"],
            userUuid: json["user_uuid"],
        );
    }
}

class UserConversation {
    DateTime createdAt;
    DateTime updatedAt;
    List<Message> messages;

    UserConversation({
        required this.createdAt,
        required this.updatedAt,
        required this.messages,
    }); 

    factory UserConversation.fromJson(Map<String, dynamic> json) {
        return UserConversation(
            createdAt: DateTime.parse(json["created_at"]),
            updatedAt: DateTime.parse(json["updated_at"]),
            messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
        );
    }
}

class Sessions {
    // TODO: Maybe improve by getting the baseUrl from the .env file
    final baseUrl = "http://localhost:3000";
    String? _sessionToken;

    String buildUrl(String endpoint) {
        return "$baseUrl/$endpoint";
    }

    Future<Map<String, String>> buildHeaders() async {
        return <String, String>{
            "Content-Type": "application/json",
            "Authorization": "Bearer ${(await _getSessionToken()) ?? ""}",
        };
    }

    Future<void> _setSessionToken(String token) async {
        _sessionToken = token;
        await SecureStore.saveSessionToken(token);
    }

    Future<String?> _getSessionToken() async {
        _sessionToken ??= await SecureStore.getSessionToken();

        return _sessionToken;
    }

    Future<void> signIn(String email, String password) async {
        final String url = buildUrl("auth/sign_in");
        // TODO: Maybe secure the password
        final body = {
            "user": {
                "email": email,
                "password": password
            }
        };
        final http.Response response = await http.post(
            Uri.parse(url),
            headers: await buildHeaders(),
            body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(response.body);
            final String token = data["token"];
            await _setSessionToken(token);
        } else {
            throw Exception("Failed to sign in");
        }
    }

    Future<void> signOut() async {
        final String url = buildUrl("auth/sign_out");
        final http.Response response = await http.delete(
            Uri.parse(url),
            headers: await buildHeaders(),
        );

        if (response.statusCode == 204) {
            _sessionToken = null;
            await SecureStore.clearSessionToken();
        } else {
            throw Exception("Failed to sign out");
        }
    }

    Future<bool> isAuthenticated() async {
        final String? token = await _getSessionToken();
        return token != null && token.isNotEmpty;
    }

    Future<void> signUp(String email, String password, String username, String phoneNumber, String publicKey, String privateKey) async {
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
            await _setSessionToken(token);
        } else {
            throw Exception("Failed to sign up");
        }
    }

    Future<void> sendMessage(String message, String conversationUuid) async {
        final String url = buildUrl("messages");
        final body = {
            "message": {
                "content": message,
                "conversation_uuid": conversationUuid
            }
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

    Future<void> createConversation(String name, List<String> participants, String publicKey, String privateKey) async {
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

    Future<void> deleteConversation(String conversationUuid) async {
        final String url = buildUrl("user_conversations/$conversationUuid");
        final http.Response response = await http.delete(
            Uri.parse(url),
            headers: await buildHeaders(),
        );

        if (response.statusCode != 204) {
            throw Exception("Failed to delete conversation");
        }
    }

    // TODO: Implement upload profile picture
    // TODO: Implement delete profile picture    

    Future<UserConversation> getAllUserConversation() async {
        final String url = buildUrl("user_conversations");
        final http.Response response = await http.get(
            Uri.parse(url),
            headers: await buildHeaders(),
        );

        if (response.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(response.body);
            return UserConversation.fromJson(data);
        } else {
            throw Exception("Failed to get user conversation");
        }
    }
}