import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Spacer to push everything down
            Spacer(flex: 1),

            // SVG Illustration (Centered and takes space)
            Expanded(
              flex: 3, // Takes 3/6 of available space
              child: SvgPicture.asset(
                "assets/undraw_mobile-encryption_flk2.svg",
                width: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 20), // Spacing between image and text

            // Title Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Text(
                "Conversations privées, sécurisées.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Spacer(flex: 1), // Pushes the button down a bit

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
                onPressed: () {
                  Navigator.pushNamed(context, '/sign_in');
                },
                child: Text("Commencer"),
              ),
            ),

            Spacer(flex: 2), // Bottom Spacer
          ],
        ),
    ));
  }
}