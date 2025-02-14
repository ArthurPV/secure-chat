import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {"name": "Celine Putri", "status": "Vu pour la dernière fois hier", "avatar": "https://placehold.co/48x48"},
    {"name": "Benoit Proulx", "status": "En ligne", "avatar": "https://placehold.co/48x48"},
    {"name": "Eve Seguin", "status": "Dernière visite il y a 3 heures", "avatar": "https://placehold.co/48x48"},
    {"name": "Nathalie Paul", "status": "En ligne", "avatar": "https://placehold.co/48x48"},
    {"name": "Robert Devon", "status": "En ligne", "avatar": "https://placehold.co/48x48"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Contacts"),
        automaticallyImplyLeading: false, // ✅ No back arrow
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(contact["avatar"]!),
            ),
            title: Text(
              contact["name"]!,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(contact["status"]!),
            onTap: () {
              // TODO: Open chat screen
            },
          );
        },
      ),
    );
  }
}
