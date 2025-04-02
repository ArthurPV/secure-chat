import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  // Import Firebase Core
import 'screens/walkthrough.dart';
import 'screens/verification_phone.dart';
import 'screens/verification_code.dart';
import 'screens/profile.dart';
import 'screens/main_screen.dart';
import 'utils/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/edit_profile.dart';
import 'screens/chat_detail.dart';
import 'screens/chats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
  String? savedUser = await LocalStorage.getUsername();

  if (isFirstLaunch) {
    await prefs.setBool('first_launch', false);
    savedUser = null; // Force the app to start fresh
  }

  runApp(SecureChatApp(isUserLoggedIn: savedUser != null));
}

class SecureChatApp extends StatelessWidget {
  final bool isUserLoggedIn;

  SecureChatApp({required this.isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SecureChat',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: isUserLoggedIn ? '/main' : '/',
      routes: {
        '/': (context) => WalkthroughScreen(),
        '/phone_verification': (context) => PhoneVerificationScreen(),
        '/verification_code': (context) => VerificationCodeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/main': (context) => MainScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
        '/chats': (context) => ChatsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat_detail') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ChatDetailScreen(chatId: args),
          );
        }
        return null;
      },
    );
  }
}
