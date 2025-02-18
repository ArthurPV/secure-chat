import 'package:flutter/material.dart';

class VerificationCodeScreen extends StatefulWidget {
  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  TextEditingController _otpController = TextEditingController();
  String _errorMessage = "";

  void _verifyCode() {
    String enteredCode = _otpController.text.trim();

    if (enteredCode.length < 6) {
      setState(() {
        _errorMessage = "Veuillez entrer un code de 6 chiffres";
      });
      return;
    }

    // 🚀 Navigate to Profile setup
    Navigator.pushNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context)!.settings.arguments as String? ?? "Numéro inconnu";
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
              Spacer(flex: 2), // Push content higher

              // Title
              Text(
                "Un code de vérification a été envoyé à",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),

              // Phone Number
              Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              SizedBox(height: screenHeight * 0.05), // Spacing

              // OTP Input Field
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, letterSpacing: 10),
                decoration: InputDecoration(
                  hintText: "000000",
                  counterText: "",
                  filled: true,
                  fillColor: Color(0xFFF7F7FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    _verifyCode(); // Auto-submit when 6 digits entered
                  }
                },
              ),
              SizedBox(height: 10),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),

              Spacer(flex: 1), // Push content up slightly

              // Confirm Button
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
                  onPressed: _verifyCode,
                  child: Text(
                    "Confirmer",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Resend Code Button
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Code renvoyé à $phoneNumber")),
                  );
                },
                child: Text(
                  "Renvoyer le code",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
