import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/data_repository.dart';
import 'chat_detail.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  final DataRepository repository = FirebaseDataRepository();

  // Create a stream that listens to chats for the current user.
  Stream<QuerySnapshot> get chatsStream {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUID)
        .snapshots();
  }

  // Opens a chat conversation using the chatId.
  void _openChat(String chatId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chatId: chatId),
      ),
    );
  }

  // Prompts the user to start a new conversation.
  // For demonstration, we pass a hard-coded receiver UID.
  void _startNewChat(String receiverUID) async {
    String chatId = await repository.createChat(receiverUID);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chatId: chatId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<Chat> chats = [];
          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            List<dynamic> messagesData = data.containsKey('messages') ? data['messages'] : [];
            List<ChatMessage> messages = messagesData
                .map((m) => ChatMessage.fromMap(m as Map<String, dynamic>))
                .toList();
            chats.add(Chat(chatId: doc.id, messages: messages));
          }
          if (chats.isEmpty) {
            return Center(child: Text("Aucune conversation trouvée"));
          }
          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              String lastMessage = chat.messages.isNotEmpty
                  ? chat.messages.last.text
                  : "Nouvelle conversation";
              return ListTile(
                leading: CircleAvatar(
                  child: Text(chat.chatId.substring(0, 1)),
                  backgroundColor: Colors.blueAccent,
                ),
                title: Text(chat.chatId), // In a real app, map chatId to a friendly name.
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  "12:00 PM", // Placeholder timestamp.
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () => _openChat(chat.chatId),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For testing: hard-coded receiver UID.
          _startNewChat("receiverUID_example");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
