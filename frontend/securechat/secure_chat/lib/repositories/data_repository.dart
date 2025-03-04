import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// --- Models ---
class UserProfile {
  final String username;
  final String profilePicture;
  UserProfile({required this.username, required this.profilePicture});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profilePicture': profilePicture,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      username: map['username'] as String,
      profilePicture: map['profilePicture'] as String,
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;

  ChatMessage({required this.sender, required this.text, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      sender: map['sender'] as String,
      text: map['text'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}


class Chat {
  final String chatId;
  final List<ChatMessage> messages;
  Chat({required this.chatId, required this.messages});
}

class Contact {
  final String name;
  final String image;
  Contact({required this.name, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }
}

/// --- Repository Interface ---
abstract class DataRepository {
  // Profile operations
  Future<UserProfile?> getUserProfile();
  Future<void> updateUserProfile(UserProfile profile);

  // Chat operations
  Future<List<Chat>> fetchChats();
  Future<void> sendMessage(String chatId, ChatMessage message);

  // Contacts operations
  Future<List<Contact>> fetchContacts();
  Future<void> addContact(Contact contact);
}

/// --- Firebase and Local Storage Implementation ---
class FirebaseDataRepository implements DataRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Get user profile from local storage.
  @override
  Future<UserProfile?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? profilePicture = prefs.getString('profile_picture');
    if (username != null && profilePicture != null) {
      return UserProfile(username: username, profilePicture: profilePicture);
    }
    return null;
  }

  /// Save/update user profile in local storage.
  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', profile.username);
    await prefs.setString('profile_picture', profile.profilePicture);
  }

  /// Fetch chats from Firestore.
  @override
  Future<List<Chat>> fetchChats() async {
    QuerySnapshot snapshot = await firestore.collection('chats').get();
    List<Chat> chats = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Check if the 'messages' field exists; if not, use an empty list.
      List<dynamic> messagesData = data.containsKey('messages') ? data['messages'] : [];
      List<ChatMessage> messages = messagesData
          .map((m) => ChatMessage.fromMap(m as Map<String, dynamic>))
          .toList();
      chats.add(Chat(chatId: doc.id, messages: messages));
    }
    return chats;
  }



  Future<void> sendMessage(String chatId, ChatMessage message) async {
    DocumentReference chatDoc = firestore.collection('chats').doc(chatId);
    await chatDoc.set({
      'messages': FieldValue.arrayUnion([message.toMap()])
    }, SetOptions(merge: true));
  }


  /// Fetch contacts stored locally (as a JSON string).
  @override
  Future<List<Contact>> fetchContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsString = prefs.getString('contacts');
    if (contactsString != null) {
      List<dynamic> decoded = json.decode(contactsString);
      return decoded.map((c) => Contact.fromMap(c as Map<String, dynamic>)).toList();
    }
    return [];
  }

  /// Add a contact and update the local storage.
  @override
  Future<void> addContact(Contact contact) async {
    List<Contact> contacts = await fetchContacts();
    contacts.add(contact);
    List<Map<String, dynamic>> contactsMap = contacts.map((c) => c.toMap()).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('contacts', json.encode(contactsMap));
  }
}
