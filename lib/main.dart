import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/':(context)=> WelcomeScreen(),
        '/login':(context)=> LoginScreen(),
        '/registration':(context)=> RegistrationScreen(),
        '/chat':(context)=> ChatScreen(),



      },
    );
  }
}