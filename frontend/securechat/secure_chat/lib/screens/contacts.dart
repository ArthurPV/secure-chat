import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'chat_detail.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/local_storage.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }


  Future<void> _loadContacts() async {
    List<dynamic> savedContacts = await LocalStorage.getContacts(); // Load dynamic list
    setState(() {
      contacts = savedContacts.map((contact) => Map<String, String>.from(contact)).toList();
    });
  }



  Future<void> _saveContacts() async {
    await LocalStorage.saveContacts(contacts.map((contact) => contact).toList());
  }



  Future<void> _startChat(String contactName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chatData = prefs.getString('chats');
    List<Map<String, dynamic>> conversations = [];

    if (chatData != null) {
      conversations = List<Map<String, dynamic>>.from(json.decode(chatData));
    }

    bool chatExists = conversations.any((chat) => chat["name"] == contactName);
    if (!chatExists) {
      setState(() {
        conversations.add({
          "name": contactName,
          "lastMessage": "Nouvelle conversation",
        });
      });
      await prefs.setString('chats', json.encode(conversations));
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(contactName: contactName),
      ),
    ).then((_) => setState(() {})); // Refresh UI after returning
  }


  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
    _saveContacts();
  }


  Future<void> _changeProfilePicture(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        contacts[index]["image"] = pickedFile.path;
      });
      _saveContacts();
    }
  }


  void _showContactOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("Démarrer une conversation"),
              onTap: () {
                Navigator.pop(context);
                _startChat(contacts[index]["name"]!);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Modifier la photo"),
              onTap: () {
                Navigator.pop(context);
                _changeProfilePicture(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Supprimer le contact", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteContact(index);
              },
            ),
          ],
        );
      },
    );
  }


  void _addContact() {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter un contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nom"),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Numéro de téléphone"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Ajouter"),
              onPressed: () {
                if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                  setState(() {
                    contacts.add({
                      "name": nameController.text,
                      "phone": phoneController.text,
                      "image": ""
                    });
                  });
                  _saveContacts();
                  Navigator.pop(context);
                }
              },
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
        title: Text("Contacts"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addContact,
          ),
        ],
      ),
      body: contacts.isEmpty
          ? Center(child: Text("Aucun contact ajouté"))
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: contacts[index]["image"]!.isNotEmpty
                  ? FileImage(File(contacts[index]["image"]!))
                  : null,
              child: contacts[index]["image"]!.isEmpty ? Icon(Icons.person) : null,
            ),
            title: Text(contacts[index]["name"]!),
            subtitle: Text(contacts[index]["phone"]!),
            onTap: () => _showContactOptions(index),
          );
        },
      ),
    );
  }
}
