import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../repositories/data_repository.dart'; // Adjust this path based on your project structure

class ChatDetailScreen extends StatefulWidget {
  final String chatId; // Unique identifier for the chat document in Firestore
  ChatDetailScreen({required this.chatId});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> messages = [];

  // Instantiate your repository
  final DataRepository repository = FirebaseDataRepository();

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  // Load the chat messages from Firestore using the repository.
  Future<void> _loadChat() async {
    List<Chat> chats = await repository.fetchChats();
    // Find the chat matching the provided chatId. If not found, create an empty chat.
    Chat currentChat = chats.firstWhere(
          (chat) => chat.chatId == widget.chatId,
      orElse: () => Chat(chatId: widget.chatId, messages: []),
    );
    setState(() {
      messages = currentChat.messages;
    });
  }

  // Send a message using the repository.
  void _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Get current user's UID as sender.
    String sender = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

    ChatMessage newMessage = ChatMessage(
      sender: sender,
      text: text,
      timestamp: DateTime.now(),
    );

    // Send the message to Firestore via the repository.
    await repository.sendMessage(widget.chatId, newMessage);

    _messageController.clear();
    // Reload the chat to update the UI.
    await _loadChat();
  }

  @override
  Widget build(BuildContext context) {
    // Get current user's UID.
    String currentUser = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        // Optionally add actions (e.g., delete conversation) here.
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text("Aucun message"))
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                ChatMessage msg = messages[index];
                bool isCurrentUser = msg.sender == currentUser;
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
                        // If the message is not from the current user, display sender info.
                        if (!isCurrentUser)
                          Text(
                            msg.sender, // You might map the UID to a display name later.
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
          ),
        ],
      ),
    );
  }
}
