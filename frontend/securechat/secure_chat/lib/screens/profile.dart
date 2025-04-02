// lib/screens/profile.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      setState(() => _errorMessage = "Le nom ne peut pas être vide");
      return;
    }
    if (passphrase.isEmpty) {
      setState(() => _errorMessage = "La passphrase ne peut pas être vide");
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _errorMessage = "Aucun utilisateur authentifié trouvé.");
      return;
    }

    // Vérifie si une clé privée existe déjà en local.
    final existingKey = await LocalStorage.getPrivateKeyForUid(uid);
    if (existingKey != null) {
      print("DEBUG: Une clé privée pour cet UID existe déjà. On ne régénère pas la clé.");
      // Attempt to decrypt the stored private key using the provided passphrase.
      try {
        final privObj = jsonDecode(existingKey);
        decryptPrivateKey(privObj['encrypted'], privObj['iv'], passphrase);
      } catch (e) {
        setState(() => _errorMessage = "Passphrase incorrecte, veuillez réessayer.");
        return;
      }
      // If decryption is successful, save the passphrase.
      await SecureStore.savePassphraseForUid(uid, passphrase);
      // Retrieve existing public key from Firestore to avoid overwriting.
      String existingPublicKey = "";
      final userDoc = await FirebaseFirestore.instance.collection('usernames').doc(name).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        existingPublicKey = data['publicKey'] ?? "";
      }
      // Update Firestore while preserving the local backup.
      await _updateFirestoreProfile(name, passphrase,
          isKeyAlreadyPresent: true,
          publicKeyPem: existingPublicKey,
          privateKeyBackup: existingKey);
      return;
    } else {
      // Si aucune clé n'existe localement, tente de récupérer le backup depuis Firestore.
      final userDoc = await FirebaseFirestore.instance.collection('usernames').doc(name).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        String? backup = data['privateKeyBackup'];
        if (backup != null && backup.isNotEmpty) {
          // Sauvegarde le backup localement.
          await LocalStorage.savePrivateKeyForUid(uid, backup);
          try {
            final privObj = jsonDecode(backup);
            decryptPrivateKey(privObj['encrypted'], privObj['iv'], passphrase);
          } catch (e) {
            setState(() => _errorMessage = "Passphrase incorrecte, veuillez réessayer.");
            return;
          }
          await SecureStore.savePassphraseForUid(uid, passphrase);
          String existingPublicKey = data['publicKey'] ?? "";
          await _updateFirestoreProfile(name, passphrase,
              isKeyAlreadyPresent: true,
              publicKeyPem: existingPublicKey,
              privateKeyBackup: backup);
          return;
        }
      }
    }

    // Aucune clé locale ou backup trouvée: on génère une nouvelle paire RSA.
    final keyPair = generateRSAKeyPair();
    final publicKeyPem = CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey);
    final privateKeyPem = CryptoUtils.encodeRSAPrivateKeyToPem(keyPair.privateKey);

    // Crypte la clé privée avec la passphrase.
    final encResult = encryptPrivateKey(privateKeyPem, passphrase);
    final encPrivateKeyJson = jsonEncode(encResult);

    // Sauvegarde localement la passphrase et la clé privée cryptée.
    await SecureStore.savePassphraseForUid(uid, passphrase);
    await LocalStorage.savePrivateKeyForUid(uid, encPrivateKeyJson);

    // Met à jour Firestore en envoyant la clé publique et la sauvegarde de la clé privée.
    await _updateFirestoreProfile(name, passphrase,
        publicKeyPem: publicKeyPem, privateKeyBackup: encPrivateKeyJson);
  }

  // Met à jour le profil dans Firestore en incluant le backup de la clé privée.
  Future<void> _updateFirestoreProfile(String name, String passphrase,
      {bool isKeyAlreadyPresent = false, String publicKeyPem = "", String privateKeyBackup = ""}) async {
    final phone = await LocalStorage.getPhoneNumber() ?? "";
    final profile = UserProfile(
      username: name,
      profilePicture: _profilePicture ?? "",
      phoneNumber: phone,
      publicKey: publicKeyPem,
      privateKeyBackup: privateKeyBackup,
    );

    try {
      await repository.updateUserProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isKeyAlreadyPresent
                ? "Profil mis à jour sans générer une nouvelle clé."
                : "Profil et clé sauvegardés !")),
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
