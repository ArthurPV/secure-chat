import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../utils/local_storage.dart';

/// --- Models ---
class UserProfile {
  final String username;
  final String profilePicture;
  final String phoneNumber;

  UserProfile({
    required this.username,
    required this.profilePicture,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profilePicture': profilePicture,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      username: map['username'] as String,
      profilePicture: map['profilePicture'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

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

// Modified Contact model now includes a receiver UID.
class Contact {
  final String id; // Firestore document ID
  final String name;
  final String image;
  final String uid; // Receiver's UID

  Contact({this.id = '', required this.name, required this.image, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'uid': uid,
    };
  }

  // Now accepts an optional id.
  factory Contact.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return Contact(
      id: id,
      name: map['name'] as String,
      image: map['image'] as String,
      uid: map['uid'] as String? ?? '',
    );
  }
}

/// --- Repository Interface ---
abstract class DataRepository {
  // Profile operations
  Future<UserProfile?> getUserProfile();
  Future<void> updateUserProfile(UserProfile profile);
  Future<UserProfile?> getUserByPhone(String phoneNumber);

  // Chat operations
  Future<List<Chat>> fetchChats();
  Future<String> createChat(String receiverUID);
  Future<void> sendMessage(String chatId, ChatMessage message);

  // Contacts operations
  Future<List<Contact>> fetchContacts();
  Future<void> addContact(Contact contact);
  Future<void> deleteContact(String contactId);
}

/// --- Firebase and Local Storage Implementation ---
class FirebaseDataRepository implements DataRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// PROFILE OPERATIONS

  @override
  Future<UserProfile?> getUserProfile() async {
    String? username = await LocalStorage.getUsername();
    String? profilePicture = await LocalStorage.getProfilePicture();
    String? phoneNumber = await LocalStorage.getPhoneNumber();
    if (username != null && profilePicture != null && phoneNumber != null) {
      return UserProfile(
        username: username,
        profilePicture: profilePicture,
        phoneNumber: phoneNumber,
      );
    }
    return null;
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String? currentUsername = await LocalStorage.getUsername();

    if (currentUsername == null || currentUsername != profile.username) {
      bool available = await isUsernameAvailable(profile.username);
      if (!available) {
        throw Exception("Username already taken");
      }
      await firestore.collection('usernames').doc(profile.username).set({
        'uid': uid,
        'username': profile.username,
        'phoneNumber': profile.phoneNumber,
        'profilePicture': profile.profilePicture,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      if (currentUsername != null) {
        await firestore.collection('usernames').doc(currentUsername).delete();
      }
    } else {
      await firestore.collection('usernames').doc(profile.username).update({
        'phoneNumber': profile.phoneNumber,
        'profilePicture': profile.profilePicture,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
    await LocalStorage.saveUsername(profile.username);
    await LocalStorage.saveProfilePicture(profile.profilePicture);
    await LocalStorage.savePhoneNumber(profile.phoneNumber);
  }

  @override
  Future<UserProfile?> getUserByPhone(String phoneNumber) async {
    QuerySnapshot snapshot = await firestore
        .collection('usernames')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
      snapshot.docs.first.data() as Map<String, dynamic>;
      return UserProfile(
        username: data['username'] ?? snapshot.docs.first.id,
        profilePicture: data['profilePicture'] ?? "",
        phoneNumber: data['phoneNumber'] as String,
      );
    }
    return null;
  }

  /// CHAT OPERATIONS

  @override
  Future<List<Chat>> fetchChats() async {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await firestore
        .collection('chats')
        .where('participants', arrayContains: currentUID)
        .get();
    List<Chat> chats = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> messagesData =
      data.containsKey('messages') ? data['messages'] : [];
      List<ChatMessage> messages = messagesData
          .map((m) => ChatMessage.fromMap(m as Map<String, dynamic>))
          .toList();
      chats.add(Chat(chatId: doc.id, messages: messages));
    }
    return chats;
  }

  @override
  Future<String> createChat(String receiverUID) async {
    if (receiverUID.isEmpty) {
      throw Exception("Receiver UID is empty");
    }
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    List<String> participants = [currentUID, receiverUID]..sort();
    String chatId = participants.join('_');
    DocumentReference chatDoc = firestore.collection('chats').doc(chatId);
    DocumentSnapshot docSnapshot = await chatDoc.get();
    if (!docSnapshot.exists) {
      await chatDoc.set({
        'participants': participants,
        'messages': []
      });
    }
    return chatId;
  }

  @override
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    DocumentReference chatDoc = firestore.collection('chats').doc(chatId);
    await chatDoc.set({
      'messages': FieldValue.arrayUnion([message.toMap()]),
    }, SetOptions(merge: true));
  }

  /// CONTACTS OPERATIONS

  @override
  Future<List<Contact>> fetchContacts() async {
    String? username = await LocalStorage.getUsername();
    if (username == null) return [];
    QuerySnapshot snapshot = await firestore
        .collection('usernames')
        .doc(username)
        .collection('contacts')
        .get();
    return snapshot.docs.map((doc) {
      return Contact.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
    }).toList();
  }

  Future<bool> doesUsernameExist(String username) async {
    DocumentSnapshot snapshot =
    await firestore.collection('usernames').doc(username).get();
    return snapshot.exists;
  }

  @override
  Future<void> addContact(Contact contact) async {
    // Check if the contact exists as a username.
    bool exists = await doesUsernameExist(contact.name);
    if (!exists) {
      throw Exception("User does not exist");
    }

    // If the contact's uid is empty, fetch it from Firestore.
    String receiverUID = contact.uid;
    if (receiverUID.isEmpty) {
      DocumentSnapshot doc = await firestore.collection('usernames').doc(contact.name).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        receiverUID = data['uid'] ?? "";
      }
    }
    if (receiverUID.isEmpty) {
      throw Exception("User UID not found");
    }

    // Create a new Contact object with the fetched UID.
    Contact newContact = Contact(name: contact.name, image: contact.image, uid: receiverUID);

    String? currentUsername = await LocalStorage.getUsername();
    if (currentUsername == null) {
      throw Exception("User not logged in");
    }

    // Prepare the data to save including the owner's uid.
    var contactData = newContact.toMap();
    contactData['ownerUid'] = FirebaseAuth.instance.currentUser!.uid;

    await firestore
        .collection('usernames')
        .doc(currentUsername)
        .collection('contacts')
        .add(contactData);
  }


  @override
  Future<void> deleteContact(String contactId) async {
    String? currentUsername = await LocalStorage.getUsername();
    if (currentUsername == null) {
      throw Exception("User not logged in");
    }
    await firestore
        .collection('usernames')
        .doc(currentUsername)
        .collection('contacts')
        .doc(contactId)
        .delete();
  }

  Future<bool> isUsernameAvailable(String username) async {
    DocumentSnapshot snapshot =
    await firestore.collection('usernames').doc(username).get();
    return !snapshot.exists;
  }
}
