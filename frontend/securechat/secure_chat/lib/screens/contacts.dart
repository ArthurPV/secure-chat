import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/data_repository.dart';
import 'chat_detail.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  final DataRepository repository = FirebaseDataRepository();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    List<Contact> fetchedContacts = await repository.fetchContacts();
    setState(() {
      contacts = fetchedContacts;
    });
  }

  // Use the contact's uid (receiverUID) to create/retrieve the proper chat.
  void _startChat(Contact contact) async {
    String receiverUID = contact.uid;
    String chatId = await repository.createChat(receiverUID);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chatId: chatId),
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
                      contacts[index] = Contact(
                        id: contacts[index].id,
                        name: contacts[index].name,
                        image: pickedFile.path,
                        uid: contacts[index].uid,
                      );
                    });
                    // Optionally, update Firestore with an update method.
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
                      contacts[index] = Contact(
                        id: contacts[index].id,
                        name: contacts[index].name,
                        image: stockPhotos[photoIndex],
                        uid: contacts[index].uid,
                      );
                    });
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

  // Add a new contact. Only ask for the contact's name.
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
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  // Create a contact with an empty uid (it will be auto-fetched)
                  Contact newContact = Contact(
                    name: nameController.text,
                    image: "", // Initially no photo.
                    uid: "",   // Leave empty; repository will fetch it.
                  );
                  try {
                    await repository.addContact(newContact);
                    Navigator.pop(context);
                    _loadContacts();
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Le nom ne peut pas être vide")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }


  // Delete a contact from Firestore and update the UI.
  void _deleteContact(int index) async {
    Contact contactToDelete = contacts[index];
    try {
      await repository.deleteContact(contactToDelete.id);
      setState(() {
        contacts.removeAt(index);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression: $e")),
      );
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
                _startChat(contacts[index]);
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
              title: Text("Supprimer le contact",
                  style: TextStyle(color: Colors.red)),
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
          String imagePath = contacts[index].image;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: imagePath.isNotEmpty
                  ? (imagePath.startsWith('assets/')
                  ? AssetImage(imagePath)
                  : FileImage(File(imagePath)) as ImageProvider)
                  : null,
              child: imagePath.isEmpty ? Icon(Icons.person) : null,
            ),
            title: Text(contacts[index].name),
            onTap: () => _showContactOptions(index),
          );
        },
      ),
    );
  }
}
