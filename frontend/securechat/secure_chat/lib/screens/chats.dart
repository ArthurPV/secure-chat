import 'package:flutter/material.dart';
import 'chat_detail.dart';

class ChatsScreen extends StatelessWidget {
  final List<Map<String, String>> conversations = [
    {"name": "Celine Putri", "message": "Bonjour, avez-vous bien dormi ?", "avatar": "https://placehold.co/48x48"},
    {"name": "Benoit Proulx", "message": "Très bien, c'est noté.", "avatar": "https://placehold.co/48x48"},
    {"name": "Eve Seguin", "message": "On se voit demain !", "avatar": "https://placehold.co/48x48"},
    {"name": "Nathalie Paul", "message": "Je suis en route.", "avatar": "https://placehold.co/48x48"},
    {"name": "Robert Devon", "message": "À quelle heure tu arrives ?", "avatar": "https://placehold.co/48x48"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Chats"),
        automaticallyImplyLeading: false, // ✅ No back arrow
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(convo["avatar"]!),
            ),
            title: Text(
              convo["name"]!,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(convo["message"]!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(name: convo["name"]!, avatar: convo["avatar"]!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
