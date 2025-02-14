import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Paramètres"),
        automaticallyImplyLeading: false, // ✅ No back arrow
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // ✅ User Profile Section
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage("https://placehold.co/100x100"),
            ),
            title: Text("Jean Marcel", style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("+1 819-545-3956"),
            trailing: Icon(Icons.edit, color: Colors.blue),
            onTap: () {
              // TODO: Navigate to Edit Profile Screen
            },
          ),
          Divider(),

          // ✅ Account Settings
          _buildSettingsOption(context, Icons.person, "Compte", "Modifier votre compte"),
          _buildSettingsOption(context, Icons.chat, "Chats", "Paramètres de conversation"),
          _buildSettingsOption(context, Icons.notifications, "Notifications", "Gérer les notifications"),
          _buildSettingsOption(context, Icons.lock, "Confidentialité", "Sécurité et confidentialité"),
          _buildSettingsOption(context, Icons.data_usage, "Utilisation des données", "Données et stockage"),

          Divider(),

          // ✅ Additional Settings
          _buildSettingsOption(context, Icons.help, "Aide", "Assistance et FAQ"),
          _buildSettingsOption(context, Icons.group, "Invitez vos amis", "Partager l'application"),
        ],
      ),
    );
  }

  // ✅ Helper function to build settings items
  Widget _buildSettingsOption(BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // TODO: Implement navigation to sub-settings
      },
    );
  }
}
