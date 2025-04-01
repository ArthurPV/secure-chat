// lib/utils/local_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalStorage {


  // ============== PER-USER ENCRYPTED PRIVATE KEY =============
  static Future<void> savePrivateKeyForUid(String uid, String encryptedPrivateKeyJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('private_key_$uid', encryptedPrivateKeyJson);
  }

  static Future<String?> getPrivateKeyForUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('private_key_$uid');
  }

  // If you want a "logout" that only clears the old user's data:
  static Future<void> clearUserData(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('private_key_$uid');
    // if you store username, phone, etc. in user-specific keys, remove them too.
  }

  // ============== LEGACY OR UNIVERSAL KEYS =============
  // If you absolutely want a single private key for the "current user" only, you can keep these:
  // (But if you do, you'll need to carefully handle multi-user switching.)
  static Future<void> savePrivateKey(String encryptedPrivateKeyJson) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // store it in the per-user key anyway
      await prefs.setString('private_key_$uid', encryptedPrivateKeyJson);
    } else {
      // fallback if somehow no user
      await prefs.setString('private_key', encryptedPrivateKeyJson);
    }
  }

  static Future<String?> getPrivateKey() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return prefs.getString('private_key_$uid');
    } else {
      return prefs.getString('private_key');
    }
  }

  // ============== USERNAME, PHONE, PICTURE =============
  // In your code you store these as well. That’s fine, but if you want them truly per account,
  // you might also store them in keys that contain the UID.
  // For now I'll show your existing approach, just keep in mind that means switching accounts
  // might overwrite them if you’re reusing the same keys.
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // do 'username_$uid'
      await prefs.setString('username_$uid', username);
    } else {
      await prefs.setString('username', username);
    }
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return prefs.getString('username_$uid');
    } else {
      return prefs.getString('username');
    }
  }

  static Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone_number', phoneNumber);
  }

  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone_number');
  }

  static Future<void> saveProfilePicture(String profileUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_picture', profileUrl);
  }

  static Future<String?> getProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_picture');
  }
}
