import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatDetailScreen extends StatefulWidget {
  final String contactName;
  ChatDetailScreen({required this.contactName});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  TextEditingController _messageController = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // Load chat messages saved under a key equal to the contact's name.
  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString(widget.contactName);
    if (chatData != null) {
      setState(() {
        messages = List<String>.from(json.decode(chatData));
      });
    }
  }

  // Save the chat messages under the contact's name.
  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.contactName, json.encode(messages));
  }

  // Update the conversation summary (lastMessage) in the "chats" key.
  Future<void> _updateConversationSummary(String newMessage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString('chats');
    if (chatData != null) {
      List<Map<String, dynamic>> convos =
      List<Map<String, dynamic>>.from(json.decode(chatData));
      for (var convo in convos) {
        if (convo["name"] == widget.contactName) {
          convo["lastMessage"] = newMessage;
          break;
        }
      }
      await prefs.setString('chats', json.encode(convos));
    }
  }

  // Send a message, update local state and conversation summary.
  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isEmpty) return;
    setState(() {
      messages.add(message);
    });
    _messageController.clear();
    await _saveMessages();
    await _updateConversationSummary(message);
  }

// Delete the entire conversation.
  void _deleteConversation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the conversation messages stored under the contact's key.
    await prefs.remove(widget.contactName);

    // Also update the conversation summary stored in 'chats'
    String? chatData = prefs.getString('chats');
    if (chatData != null) {
      List<Map<String, dynamic>> convos = List<Map<String, dynamic>>.from(json.decode(chatData));
      // Remove the conversation summary for this contact
      convos.removeWhere((chat) => chat["name"] == widget.contactName);
      await prefs.setString('chats', json.encode(convos));
    }

    Navigator.pop(context); // Return to the Chats screen.
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.contactName),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteConversation,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[index],
                      style: TextStyle(color: Colors.white),
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
