import 'package:flutter/material.dart';
import '../repositories/data_repository.dart'; // Adjust the import path as needed

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Create an instance of the repository.
  final DataRepository repository = FirebaseDataRepository();

  TextEditingController _nameController = TextEditingController();
  String? _profilePicture;
  String? _errorMessage;
  bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load profile data using the repository.
  void _loadUserData() async {
    var profile = await repository.getUserProfile();
    setState(() {
      if (profile != null) {
        _nameController.text = profile.username;
        _profilePicture = profile.profilePicture;
      }
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

    // Create a profile object using the current name and picture.
    var profile = UserProfile(
      username: name,
      profilePicture: _profilePicture ?? "",
    );
    await repository.updateUserProfile(profile);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profil sauvegardé!")),
    );

    // Navigate to Main Screen after saving.
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
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Selection
            GestureDetector(
              onTap: () {
                setState(() {
                  // Simulate an image selection.
                  _profilePicture = "https://placehold.co/100";
                });
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
