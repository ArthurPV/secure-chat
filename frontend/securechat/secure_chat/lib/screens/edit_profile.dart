import 'package:flutter/material.dart';
import '../repositories/data_repository.dart'; // Adjust the import path as needed
import '../utils/local_storage.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Create an instance of the repository.
  final DataRepository repository = FirebaseDataRepository();

  TextEditingController _nameController = TextEditingController();
  String? _profilePicture;
  String _errorMessage = "";
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load the current profile using the repository.
  void _loadUserData() async {
    var profile = await repository.getUserProfile();
    setState(() {
      if (profile != null) {
        _nameController.text = profile.username;
        _profilePicture = profile.profilePicture;
      }
      _validateInput(_nameController.text);
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
    // Retrieve phone number from local storage.
    String? phone = await LocalStorage.getPhoneNumber();
    var profile = UserProfile(
      username: name,
      profilePicture: _profilePicture ?? "",
      phoneNumber: phone ?? "",
    );
    try {
      await repository.updateUserProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil mis à jour!")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Modifier le profil"),
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
                  // Simulate image selection.
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
              onChanged: _validateInput,
              decoration: InputDecoration(
                labelText: "Modifier votre nom",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
            ),
            SizedBox(height: 20),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _saveUserData : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled ? Color(0xFF4B00FA) : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Enregistrer",
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
