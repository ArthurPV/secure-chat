import 'package:flutter/material.dart';
import '../utils/local_storage.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  String? _profilePicture;
  String _errorMessage = "";
  bool _isButtonEnabled = false;

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
      _validateInput(savedName ?? ""); // Validate input on load
    });
  }

  void _validateInput(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _errorMessage = "Le nom ne peut pas être vide";
        _isButtonEnabled = false;
      } else {
        _errorMessage = "";
        _isButtonEnabled = true;
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

    await LocalStorage.saveUsername(name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profil mis à jour!")),
    );
    Navigator.pop(context); // 🚀 Return to Settings
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Fix background color
      appBar: AppBar(
        title: Text("Modifier le profil"),
        backgroundColor: Colors.white, // ✅ Match background
        elevation: 0, // ✅ Remove shadow
        iconTheme: IconThemeData(color: Colors.black), // ✅ Ensure visibility
      ),
      body: Container(
        color: Colors.white, // ✅ Double check background stays white
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
              onChanged: _validateInput, // ✅ Validate input while typing
              decoration: InputDecoration(
                labelText: "Modifier votre nom",
                filled: true, // ✅ Ensures white background
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null, // ✅ Show error if needed
              ),
            ),
            SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _saveUserData : null, // ✅ Disable button if invalid
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled ? Color(0xFF4B00FA) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Enregistrer",
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
