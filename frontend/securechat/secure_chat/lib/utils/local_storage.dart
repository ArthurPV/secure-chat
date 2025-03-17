import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class LocalStorage {
  static String _usernameKey() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null ? 'username_$uid' : 'username';
  }

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey(), username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey());
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

  static Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDarkMode);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dark_mode') ?? false;
  }

  // Generate a unique key for contacts based on the current user's UID.
  static String _contactsKey() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null ? 'contacts_$uid' : 'contacts';
  }

  static Future<void> saveContacts(List<Map<String, dynamic>> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contactsKey(), json.encode(contacts));
  }

  static Future<List<Map<String, dynamic>>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    String? contactData = prefs.getString(_contactsKey());
    if (contactData != null) {
      List<dynamic> decodedContacts = json.decode(contactData);
      return decodedContacts
          .map((contact) => Map<String, dynamic>.from(contact))
          .toList();
    }
    return [];
  }

  static Future<void> clearContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_contactsKey());
  }

  // --- New methods for storing the private key ---

  // Generate a unique key for storing the private key based on the current user's UID.
  static String _privateKey() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null ? 'private_key_$uid' : 'private_key';
  }

  // Save the private key (as a PEM string) to local storage.
  static Future<void> savePrivateKey(String privateKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_privateKey(), privateKey);
  }

  // Retrieve the private key from local storage.
  static Future<String?> getPrivateKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_privateKey());
  }
}
