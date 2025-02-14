import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
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

              // Profile Picture Section
              Stack(
                alignment: Alignment.center,
                children: [
                  // Profile Picture Container
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFF7F7FC),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  // Edit Icon (Positioned Over Profile Picture)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.05), // Spacing

              // First Name Input Field
              TextField(
                decoration: InputDecoration(
                  hintText: "Prénom (obligatoire)",
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

              SizedBox(height: 15), // Spacing

              // Last Name Input Field
              TextField(
                decoration: InputDecoration(
                  hintText: "Nom de famille (facultatif)",
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

              Spacer(flex: 2), // Push everything up

              // Save Button
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
                    Navigator.pushNamed(context, '/main');
                  },
                  child: Text(
                    "Sauvegarder",
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
