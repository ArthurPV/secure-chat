import 'package:flutter/material.dart';
import 'screens/walkthrough.dart';
import 'screens/verification_phone.dart';
import 'screens/verification_code.dart';
import 'screens/profile.dart';
import 'screens/main_screen.dart';
import 'screens/chat_detail.dart'; //

void main() {
  runApp(SecureChatApp());
}

class SecureChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SecureChat',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => WalkthroughScreen(),
        '/phone_verification': (context) => PhoneVerificationScreen(),
        '/verification_code': (context) => VerificationCodeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/main': (context) => MainScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat_detail') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: args['name']!,
              avatar: args['avatar']!,
            ),
          );
        }
        return null;
      },
    );
  }
}
