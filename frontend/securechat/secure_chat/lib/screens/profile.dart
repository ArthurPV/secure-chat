// lib/screens/profile.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/data_repository.dart';
import '../utils/local_storage.dart';
import '../utils/crypto_utils.dart';
import '../utils/sercure_store.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DataRepository repository = FirebaseDataRepository();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passphraseController = TextEditingController();
  String? _profilePicture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final profile = await repository.getUserProfile();
    if (profile != null) {
      setState(() {
        _nameController.text = profile.username;
        _profilePicture = profile.profilePicture;
      });
    }
  }

  Future<void> _saveUserData() async {
    final name = _nameController.text.trim();
    final passphrase = _passphraseController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = "Name cannot be empty");
      return;
    }
    if (passphrase.isEmpty) {
      setState(() => _errorMessage = "Passphrase cannot be empty");
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _errorMessage = "No authenticated user found.");
      return;
    }

    // 1) Check if we already have a local private key for this user.
    final existingKey = await LocalStorage.getPrivateKeyForUid(uid);
    if (existingKey != null) {
      // Key already exists; we skip new generation.
      print("DEBUG: A private key for this UID already exists. Skipping new generation.");

      // Save the passphrase even if a key exists so that decryption can work.
      await SecureStore.savePassphraseForUid(uid, passphrase);

      // Retrieve the existing public key from Firestore to avoid overwriting it with an empty string.
      String existingPublicKey = "";
      final userDoc = await FirebaseFirestore.instance.collection('usernames').doc(name).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        existingPublicKey = data['publicKey'] ?? "";
      }
      await _updateFirestoreProfile(name, passphrase, isKeyAlreadyPresent: true, publicKeyPem: existingPublicKey);
      return;
    }

    // 2) If no existing key, generate a new key pair.
    final keyPair = generateRSAKeyPair();
    final publicKeyPem = CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey);
    final privateKeyPem = CryptoUtils.encodeRSAPrivateKeyToPem(keyPair.privateKey);

    // 3) Encrypt the private key with the passphrase.
    final encResult = encryptPrivateKey(privateKeyPem, passphrase);
    final encPrivateKeyJson = jsonEncode(encResult);

    // 4) Save passphrase and encrypted key.
    await SecureStore.savePassphraseForUid(uid, passphrase);
    await LocalStorage.savePrivateKeyForUid(uid, encPrivateKeyJson);

    // 5) Write public key to Firestore.
    await _updateFirestoreProfile(name, passphrase, publicKeyPem: publicKeyPem);
  }

  // Helper to write profile details to Firestore.
  Future<void> _updateFirestoreProfile(
      String name,
      String passphrase, {
        bool isKeyAlreadyPresent = false,
        String publicKeyPem = "",
      }) async {
    final phone = await LocalStorage.getPhoneNumber() ?? "";
    final profile = UserProfile(
      username: name,
      profilePicture: _profilePicture ?? "",
      phoneNumber: phone,
      publicKey: publicKeyPem, // Will be non-empty if key is new or preserved.
    );

    try {
      await repository.updateUserProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isKeyAlreadyPresent
            ? "Profile updated without generating a new key."
            : "Profile & key saved!")),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/main');
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Votre Profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Entrez votre nom",
                errorText: _errorMessage,
              ),
            ),
            TextField(
              controller: _passphraseController,
              decoration: InputDecoration(
                labelText: "Passphrase pour clé privée",
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _saveUserData,
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
