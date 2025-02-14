import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Spacer
              Spacer(flex: 1),

              // Title Section
              Text(
                "Entrez votre numéro de téléphone",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10), // Spacing
              Text(
                "Veuillez confirmer votre code pays et saisir votre numéro de téléphone",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: screenHeight * 0.05), // Spacing

              // Phone Number Input Section
              Row(
                children: [
                  // Country Code Field
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F7FC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "+1", // Default country code
                      style: TextStyle(
                        color: Color(0xFF0F1828),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Spacing
                  // Phone Number Input Field
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Numéro de téléphone",
                        hintStyle: TextStyle(color: Color(0xFFADB5BD)),
                        filled: true,
                        fillColor: Color(0xFFF7F7FC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),

              Spacer(flex: 2), // Push everything up

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4B00FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/verification_code');
                  },
                  child: Text(
                    "Continuer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Spacer(flex: 3), // Bottom space

              // Bottom Indicator
              Container(
                width: screenWidth * 0.4,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFF0F1828),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              SizedBox(height: 20), // Extra bottom spacing
            ],
          ),
        ),
      ),
    );
  }
}
