import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/local_storage.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  TextEditingController _phoneController = TextEditingController();
  String _countryCode = "+1"; // Default country code
  String _errorMessage = "";
  bool _isButtonEnabled = false;

  void _validatePhoneNumber(String value) {
    setState(() {
      if (value.length != 10) {
        _errorMessage = "Le numéro doit contenir exactement 10 chiffres";
        _isButtonEnabled = false;
      } else {
        _errorMessage = "";
        _isButtonEnabled = true;
      }
    });
  }

  void _continue() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.length != 10) {
      setState(() {
        _errorMessage = "Le numéro doit contenir exactement 10 chiffres";
      });
      return;
    }

    String fullNumber = "$_countryCode $phoneNumber";

    await LocalStorage.savePhoneNumber(fullNumber);

    // 🚀 Navigate to OTP verification screen with phone number
    Navigator.pushNamed(context, '/verification_code', arguments: fullNumber);
  }

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
              Spacer(flex: 1),

              // Title
              Text(
                "Entrez votre numéro de téléphone",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),

              // Description
              Text(
                "Veuillez confirmer votre code pays et saisir votre numéro de téléphone",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Phone Number Input
              Row(
                children: [
                  // Country Code
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F7FC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _countryCode,
                      style: TextStyle(
                        color: Color(0xFF0F1828),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),

                  // Phone Number Field
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: _validatePhoneNumber,
                      decoration: InputDecoration(
                        hintText: "Numéro de téléphone",
                        counterText: "", // Hide counter text
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

              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              Spacer(flex: 2),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? Color(0xFF4B00FA) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isButtonEnabled ? _continue : null,
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

              Spacer(flex: 3),

              // Bottom Indicator
              Container(
                width: screenWidth * 0.4,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFF0F1828),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
