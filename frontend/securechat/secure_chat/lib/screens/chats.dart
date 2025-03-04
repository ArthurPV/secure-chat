import 'package:flutter/material.dart';
import '../repositories/data_repository.dart'; // Adjust path as needed
import 'chat_detail.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  List<Chat> chats = [];
  final DataRepository repository = FirebaseDataRepository();

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  // Public method to load chats from Firestore via the repository.
  Future<void> loadChats() async {
    List<Chat> fetchedChats = await repository.fetchChats();
    setState(() {
      chats = fetchedChats;
    });
  }

  // Opens a chat conversation based on the chatId.
  void _openChat(String chatId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chatId: chatId),
      ),
    );
    loadChats(); // Refresh chats when returning.
  }

  // Prompts the user to start a new conversation.
  void _startNewChat() {
    TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nouvelle conversation"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Nom du contact"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                String contactName = _nameController.text.trim();
                if (contactName.isNotEmpty) {
                  // Create new chat. Here, we're simulating new chat creation by generating a unique chatId.
                  String newChatId = DateTime.now().millisecondsSinceEpoch.toString();
                  // In a full implementation, you might create the chat document in Firestore via the repository.
                  await loadChats();
                  Navigator.pop(context);
                  _openChat(newChatId);
                }
              },
              child: Text("Créer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Chats"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.blue),
            onPressed: _startNewChat,
          ),
        ],
      ),
      body: chats.isEmpty
          ? Center(child: Text("Aucune conversation trouvée"))
          : ListView.separated(
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
            title: Text(chat.chatId), // You can later show the contact's name.
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
      ),
    );
  }
}
