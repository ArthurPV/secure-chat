// lib/screens/edit_profile.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/local_storage.dart';          // Pour sauvegarder les données localement
import '../utils/crypto_utils.dart';           // Pour générer et chiffrer les clés RSA

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Contrôleurs pour le nom et le passphrase
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passphraseController = TextEditingController();
  String? _profilePicture;
  String _errorMessage = "";
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Charge les données du profil depuis Firebase
  void _loadUserData() async {
    // var profile = await repository.getUserProfile();
    // setState(() {
    //   if (profile != null) {
    //     _nameController.text = profile.username;
    //     _profilePicture = profile.profilePicture;
    //   }
    //   _validateInput(_nameController.text);
    // });
  }

  // Vérifie que le nom n'est pas vide
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

  // Sauvegarde le profil et intègre la génération de clés RSA
  void _saveUserData() async {
    // String name = _nameController.text.trim();
    // String passphrase = _passphraseController.text.trim();

    // // Vérifie que le nom et le passphrase sont renseignés
    // if (name.isEmpty) {
    //   setState(() {
    //     _errorMessage = "Le nom ne peut pas être vide";
    //   });
    //   return;
    // }
    // if (passphrase.isEmpty) {
    //   setState(() {
    //     _errorMessage = "Un passphrase est requis pour sécuriser votre clé privée";
    //   });
    //   return;
    // }

    // // Récupère le numéro de téléphone stocké localement (déjà sauvegardé lors de la vérification)
    // String? phone = await LocalStorage.getPhoneNumber();

    // // --- Étape 1 : Génération de la paire de clés RSA ---
    // // Cette fonction crée une clé publique et une clé privée.
    // final keyPair = generateRSAKeyPair();
    // // Pour l'instant, on convertit les clés en chaînes via .toString()
    // // (en production, vous devriez les encoder en format PEM).
    // String publicKeyStr = keyPair.publicKey.toString();
    // String privateKeyStr = keyPair.privateKey.toString();

    // // --- Étape 2 : Chiffrement de la clé privée ---
    // // On chiffre la clé privée avec le passphrase de l'utilisateur.
    // final encryptionResult = encryptPrivateKey(privateKeyStr, passphrase);
    // String encryptedPrivateKeyJson = jsonEncode(encryptionResult);

    // // --- Étape 3 : Sauvegarde locale de la clé privée chiffrée ---
    // // On enregistre la clé privée chiffrée sur l'appareil pour la récupérer plus tard.
    // await LocalStorage.savePrivateKey(encryptedPrivateKeyJson);

    // // --- Étape 4 : Mise à jour du profil sur Firebase ---
    // // On crée un objet profil incluant le nom, la photo, le numéro de téléphone
    // // et la clé publique, qui sera envoyée à Firebase.
    // var profile = UserProfile(
    //   username: name,
    //   profilePicture: _profilePicture ?? "",
    //   phoneNumber: phone ?? "",
    //   publicKey: publicKeyStr,  // La clé publique sera accessible par d'autres utilisateurs
    // );

    // try {
    //   await repository.updateUserProfile(profile);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Profil sauvegardé!")),
    //   );
    //   Navigator.pop(context);
    // } catch (e) {
    //   setState(() {
    //     _errorMessage = e.toString();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Modifier le profil"),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: Colors.black),
      // ),
      // body: Container(
      //   padding: EdgeInsets.all(16),
      //   color: Colors.white,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       // Sélection de la photo de profil
      //       GestureDetector(
      //         onTap: () {
      //           setState(() {
      //             // Ici, on simule la sélection d'une image.
      //             _profilePicture = "https://placehold.co/100";
      //           });
      //         },
      //         child: CircleAvatar(
      //           radius: 50,
      //           backgroundImage: _profilePicture != null
      //               ? NetworkImage(_profilePicture!)
      //               : null,
      //           child: _profilePicture == null
      //               ? Icon(Icons.person, size: 50, color: Colors.grey)
      //               : null,
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       // Champ de saisie pour le nom
      //       TextField(
      //         controller: _nameController,
      //         onChanged: _validateInput,
      //         decoration: InputDecoration(
      //           labelText: "Modifier votre nom",
      //           filled: true,
      //           fillColor: Colors.white,
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       // Nouveau champ de saisie pour le passphrase
      //       TextField(
      //         controller: _passphraseController,
      //         decoration: InputDecoration(
      //           labelText: "Entrez un passphrase pour votre clé privée",
      //           filled: true,
      //           fillColor: Colors.white,
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
      //         ),
      //         obscureText: true,
      //       ),
      //       SizedBox(height: 20),
      //       // Bouton de sauvegarde
      //       SizedBox(
      //         width: double.infinity,
      //         child: ElevatedButton(
      //           onPressed: _isButtonEnabled ? _saveUserData : null,
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: _isButtonEnabled ? Color(0xFF4B00FA) : Colors.grey,
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(30),
      //             ),
      //             padding: EdgeInsets.symmetric(vertical: 16),
      //           ),
      //           child: Text(
      //             "Enregistrer",
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 16,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
