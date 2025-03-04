import 'dart:io';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:image_picker/image_picker.dart';
import '../utils/local_storage.dart';
import 'chat_detail.dart'; // Import the ChatDetailScreen

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
    List<Map<String, String>> savedContacts = await LocalStorage.getContacts();
    setState(() {
      contacts = savedContacts;
    });
  }

  Future<void> _saveContacts() async {
    await LocalStorage.saveContacts(contacts);
  }

  void _startChat(Map<String, String> contact) async {
    String contactName = contact["name"]!;
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
        "image": contact["image"] ?? "",
      });
    } else {
      // Optionally update the conversation image in case it changed
      for (var chat in conversations) {
        if (chat["name"] == contactName) {
          chat["image"] = contact["image"] ?? "";
          break;
        }
      }
    }
    await prefs.setString('chats', json.encode(conversations));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chatId: contactName),
      ),
    );
  }


  void _changeProfilePicture(int index) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Importer depuis la galerie"),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      contacts[index]["image"] = pickedFile.path;
                    });
                    _saveContacts();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Choisir une image stock"),
                onTap: () {
                  Navigator.pop(context);
                  _chooseStockPhoto(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _chooseStockPhoto(int index) {
    // List of asset paths for stock photos
    final stockPhotos = [
      'assets/default1.png',
      'assets/default2.png',
      'assets/default3.png',
      'assets/default4.png',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choisissez une image"),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: stockPhotos.length,
              itemBuilder: (context, photoIndex) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      contacts[index]["image"] = stockPhotos[photoIndex];
                    });
                    _saveContacts();
                    Navigator.pop(context);
                  },
                  child: Image.asset(stockPhotos[photoIndex]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _addContact() {
    TextEditingController nameController = TextEditingController();

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
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    contacts.add({
                      "name": nameController.text,
                      "image": "" // Initially no photo
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

  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
    _saveContacts();
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
                _startChat(contacts[index]);  // Pass the entire contact map
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
          String imagePath = contacts[index]["image"] ?? "";
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: imagePath.isNotEmpty
                  ? (imagePath.startsWith('assets/')
                  ? AssetImage(imagePath)
                  : FileImage(File(imagePath)) as ImageProvider)
                  : null,
              child: imagePath.isEmpty ? Icon(Icons.person) : null,
            ),
            title: Text(contacts[index]["name"]!),
            onTap: () => _showContactOptions(index),
          );
        },
      ),
    );
  }
}
