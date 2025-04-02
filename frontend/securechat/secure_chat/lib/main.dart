import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/walkthrough.dart';
// import 'screens/profile.dart';
import 'screens/main_screen.dart';
// import 'screens/edit_profile.dart';
import 'screens/chat_detail.dart';
// import 'screens/chats.dart';
import 'screens/sign_up.dart';
import 'screens/sign_in.dart';
import 'utils/local_storage.dart';

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
        // '/profile': (context) => ProfileScreen(),
        '/main': (context) => MainScreen(),
        // '/edit_profile': (context) => EditProfileScreen(),
        // '/chats': (context) => ChatsScreen(),
        '/sign_up': (context) => SignUpScreen(),
        '/sign_in': (context) => SignInScreen(),
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
