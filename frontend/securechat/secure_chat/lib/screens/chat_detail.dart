import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String name;
  final String avatar;

  ChatDetailScreen({required this.name, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(avatar)),
            SizedBox(width: 10),
            Text(name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildMessage(true, "Salut ! Comment ça va ?"),
                _buildMessage(false, "Très bien, et toi ?"),
                _buildMessage(true, "Je vais bien aussi !"),
                _buildMessage(false, "Cool, qu'est-ce que tu fais ?"),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // ✅ Builds chat messages
  Widget _buildMessage(bool isMe, String text) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // ✅ Builds message input field
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Tapez votre message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              // TODO: Send message logic
            },
          ),
        ],
      ),
    );
  }
}
