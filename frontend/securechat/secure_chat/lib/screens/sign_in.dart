import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secure_chat/sessions.dart'; // Import flutter_svg package

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> _doSignIn(String email, String password) async {
    Sessions sessions = Sessions();
    return await sessions.signIn(email, password);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Spacer to push everything down
            SizedBox(height: 100),

            // TODO: Maybe put a logo or something here

            Text(
              "Se connecter",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0F1828),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 40),

            // Input Field for Email
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Spacer(flex: 1),

            // Input Field for Password
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Spacer(flex: 1),

            // Start Button (Properly Spaced)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B00FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                onPressed: () async {
                  if (await _doSignIn(emailController.text, passwordController.text) && context.mounted) {
                    Navigator.pushNamed(context, '/main');
                  } else {
                    // Handle sign-in failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Échec de la connexion")),
                    );
                  }
                },
                child: Text(
                  "Se connecter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )
                ),
              ),
            ),

            Spacer(flex: 2), // Bottom Spacer
          ],
        ),
      ), 
    );
  }
}