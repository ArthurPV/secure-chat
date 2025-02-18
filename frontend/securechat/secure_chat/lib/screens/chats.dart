import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'chat_detail.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Map<String, dynamic>> conversations = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString('chats');
    if (chatData != null) {
      setState(() {
        conversations = List<Map<String, dynamic>>.from(json.decode(chatData));
      });
    }
  }

  void _openChat(String contactName) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(contactName: contactName),
      ),
    );
    _loadChats(); // ✅ Refresh chat list when returning
  }

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
              onPressed: () {
                String contactName = _nameController.text.trim();
                if (contactName.isNotEmpty) {
                  _createAndOpenChat(contactName);
                  Navigator.pop(context);
                }
              },
              child: Text("Créer"),
            ),
          ],
        );
      },
    );
  }

  void _createAndOpenChat(String contactName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString('chats');
    List<Map<String, dynamic>> conversations = [];

    if (chatData != null) {
      conversations = List<Map<String, dynamic>>.from(json.decode(chatData));
    }

    bool chatExists = conversations.any((chat) => chat["name"] == contactName);
    if (!chatExists) {
      conversations.add({
        "name": contactName,
        "lastMessage": "Nouvelle conversation",
      });
      await prefs.setString('chats', json.encode(conversations));
    }

    _loadChats(); // ✅ Refresh chat list immediately

    // ✅ Open chat immediately
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatDetailScreen(contactName: contactName)),
    ).then((_) => _loadChats()); // ✅ Refresh UI after returning
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
      body: conversations.isEmpty
          ? Center(child: Text("Aucune conversation trouvée"))
          : ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(conversations[index]["name"]),
            subtitle: Text(conversations[index]["lastMessage"] ?? "Aucun message"),
            onTap: () => _openChat(conversations[index]["name"]),
          );
        },
      ),
    );
  }
}
