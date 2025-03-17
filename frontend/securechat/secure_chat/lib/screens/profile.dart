import 'dart:convert';
import 'package:flutter/material.dart';
import '../repositories/data_repository.dart';
import '../utils/local_storage.dart';
import '../utils/crypto_utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataRepository repository = FirebaseDataRepository();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passphraseController = TextEditingController(); // New controller for passphrase
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
    String passphrase = _passphraseController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = "Le nom ne peut pas être vide";
      });
      return;
    }
    if (passphrase.isEmpty) {
      setState(() {
        _errorMessage = "Un passphrase est requis pour sécuriser votre clé privée";
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
      // Generate an RSA key pair.
      final keyPair = generateRSAKeyPair();
      // For demonstration purposes, we simply convert the private key to string.
      // In a real-world scenario, you'll want to properly encode it as PEM.
      String privateKeyStr = keyPair.privateKey.toString();

      // Encrypt the private key with the passphrase.
      final encryptionResult = encryptPrivateKey(privateKeyStr, passphrase);

      // Save the encrypted private key (as a JSON string) in local storage.
      String encryptedPrivateKeyJson = jsonEncode(encryptionResult);
      await LocalStorage.savePrivateKey(encryptedPrivateKeyJson);

      // Save the profile via your repository.
      await repository.updateUserProfile(profile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil sauvegardé!")),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/main');
      });
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
            // Passphrase Input Field
            TextField(
              controller: _passphraseController,
              decoration: InputDecoration(
                labelText: "Entrez un passphrase pour votre clé privée",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _errorMessage,
              ),
              obscureText: true,
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
