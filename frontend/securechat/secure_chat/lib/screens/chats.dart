import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_detail.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  List<Map<String, dynamic>> conversations = [];

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  /// Loads the conversation list from SharedPreferences.
  Future<void> loadChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString('chats');
    setState(() {
      conversations = chatData != null
          ? List<Map<String, dynamic>>.from(json.decode(chatData))
          : [];
    });
  }

  /// Opens a chat conversation for the given contact name.
  void _openChat(String contactName) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(contactName: contactName),
      ),
    );
    loadChats(); // Refresh conversations when returning.
  }

  /// Prompts the user to start a new conversation.
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

  /// Creates a new conversation if one does not exist, then opens it.
  void _createAndOpenChat(String contactName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString('chats');

    if (chatData != null) {
      conversations = List<Map<String, dynamic>>.from(json.decode(chatData));
    } else {
      conversations = [];
    }

    bool chatExists =
    conversations.any((chat) => chat["name"] == contactName);
    if (!chatExists) {
      setState(() {
        conversations.add({
          "name": contactName,
          "lastMessage": "Nouvelle conversation",
          "image": "" // No image by default; can be updated via contacts.
        });
      });
      await prefs.setString('chats', json.encode(conversations));
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(contactName: contactName),
      ),
    ).then((_) => loadChats());
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
          : ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          String? imagePath = conversation["image"];
          ImageProvider<Object>? avatarImage;
          if (imagePath != null && imagePath.isNotEmpty) {
            avatarImage = imagePath.startsWith('assets/')
                ? AssetImage(imagePath) as ImageProvider<Object>
                : FileImage(File(imagePath)) as ImageProvider<Object>;
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: avatarImage,
              backgroundColor:
              avatarImage == null ? Colors.blueAccent : null,
              child: avatarImage == null
                  ? Text(
                conversation["name"][0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              )
                  : null,
            ),
            title: Text(
              conversation["name"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conversation["lastMessage"] ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              "12:00 PM", // Placeholder timestamp; update as needed.
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () => _openChat(conversation["name"]),
          );
        },
      ),
    );
  }
}
