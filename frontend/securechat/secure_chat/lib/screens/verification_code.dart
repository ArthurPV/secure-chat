import 'package:flutter/material.dart';

class VerificationCodeScreen extends StatelessWidget {
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
                "Entrez le code",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10), // Spacing
              Text(
                "Nous vous avons envoyé un SMS avec le code au +1 581 - 478 - 3030",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: screenHeight * 0.05), // Spacing

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F7FC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F1828),
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              Spacer(flex: 2), // Push everything up

              // Resend Code Button
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Text(
                  "Renvoyer le code",
                  style: TextStyle(
                    color: Color(0xFF4B00FA),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 15), // Space between button and bottom

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
