import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth
import '../utils/local_storage.dart';
import 'edit_profile.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _username;
  String? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    String? savedName = await LocalStorage.getUsername();
    String? savedPhone = await LocalStorage.getPhoneNumber();

    setState(() {
      _username = savedName ?? "Unknown User";
      _phoneNumber = savedPhone ?? "Not Set";
    });
  }

  void _logout(BuildContext context) async {
    // Sign out from Firebase authentication.
    await FirebaseAuth.instance.signOut();

    // Do NOT clear contacts or conversation data, so they persist.
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('chats');
    // await LocalStorage.clearContacts();

    // Redirect to Walkthrough/Login screen.
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _openEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen()),
    ).then((_) {
      _loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Paramètres"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // User Profile Info
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text(_username ?? "Loading...", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Phone: $_phoneNumber"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _openEditProfile(context),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              // Logout Button
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Déconnexion", style: TextStyle(color: Colors.red)),
                onTap: () => _logout(context),
                trailing: Icon(Icons.exit_to_app, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
