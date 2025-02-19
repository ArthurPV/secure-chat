import 'package:flutter/material.dart';
import '../utils/local_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  String? _profilePicture;
  String? _errorMessage;
  bool _isButtonEnabled = true; // Button is enabled by default

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    String? savedName = await LocalStorage.getUsername();
    String? savedProfilePicture = await LocalStorage.getProfilePicture();

    setState(() {
      if (savedName != null) _nameController.text = savedName;
      _profilePicture = savedProfilePicture;
    });
  }

  void _saveUserData() async {
    String name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = "Le nom ne peut pas être vide";
      });
      return;
    }

    await LocalStorage.saveUsername(name);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profil sauvegardé!")),
    );

    // 🚀 Navigate to Main Screen after saving
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Votre Profil"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Selection
            GestureDetector(
              onTap: () {
                setState(() {
                  _profilePicture =
                  "https://placehold.co/100"; // Simulated image selection
                });
                LocalStorage.saveProfilePicture(_profilePicture!);
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profilePicture != null
                    ? NetworkImage(_profilePicture!)
                    : null,
                child: _profilePicture == null
                    ? Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            SizedBox(height: 20),

            // Name Input Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Entrez votre nom",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B00FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Sauvegarder",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
