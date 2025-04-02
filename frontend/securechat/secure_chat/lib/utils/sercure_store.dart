// lib/utils/sercure_store.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveSessionToken(String token) async {
    await _storage.write(key: 'sessionToken', value: token);
  }

  static Future<String?> getSessionToken() async {
    return await _storage.read(key: 'sessionToken');
  }

  static Future<void> clearSessionToken() async {
    await _storage.delete(key: 'sessionToken');
  }

  static Future<void> saveCurrentUser(String userUuid) async {
    await _storage.write(key: 'currentUser', value: userUuid);
  }

  static Future<String?> getCurrentUser() async {
    return await _storage.read(key: 'currentUser');
  }

  static Future<void> clearCurrentUser() async {
    await _storage.delete(key: 'currentUser');
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Save passphrase for a specific UID
  static Future<void> savePassphraseForUid(
      String uid, String passphrase) async {
    await _storage.write(key: 'privateKeyPassphrase_$uid', value: passphrase);
  }

  static Future<String?> getPassphraseForUid(String uid) async {
    return await _storage.read(key: 'privateKeyPassphrase_$uid');
  }

  static Future<void> clearPassphraseForUid(String uid) async {
    await _storage.delete(key: 'privateKeyPassphrase_$uid');
  }

  // If you want a single passphrase for the "current user" only, keep these:
  static Future<void> savePassphrase(String passphrase) async {
    await _storage.write(key: 'privateKeyPassphrase', value: passphrase);
  }

  static Future<String?> getPassphrase() async {
    return await _storage.read(key: 'privateKeyPassphrase');
  }

  static Future<void> clearPassphrase() async {
    await _storage.delete(key: 'privateKeyPassphrase');
  }
}
