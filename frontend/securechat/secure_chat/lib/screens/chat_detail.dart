import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../repositories/data_repository.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  ChatDetailScreen({required this.chatId});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final DataRepository repository = FirebaseDataRepository();
  final TextEditingController _messageController = TextEditingController();

  // Stream that listens to changes in the chat document.
  Stream<DocumentSnapshot> get chatStream {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .snapshots();
  }

  void _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;
    String senderUID = FirebaseAuth.instance.currentUser!.uid;
    ChatMessage newMessage = ChatMessage(
      sender: senderUID,
      text: text,
      timestamp: DateTime.now(),
    );
    await repository.sendMessage(widget.chatId, newMessage);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: chatStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
                List<dynamic> messagesData = data?['messages'] ?? [];
                List<ChatMessage> messages = messagesData
                    .map((m) => ChatMessage.fromMap(m as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    ChatMessage msg = messages[index];
                    bool isCurrentUser = msg.sender == currentUID;
                    return Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Colors.blueAccent : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isCurrentUser)
                              Text(
                                msg.sender,
                                style: TextStyle(color: Colors.white70, fontSize: 10),
                              ),
                            Text(
                              msg.text,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 4),
                            Text(
                              DateFormat('hh:mm a').format(msg.timestamp),
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Écrire un message...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
