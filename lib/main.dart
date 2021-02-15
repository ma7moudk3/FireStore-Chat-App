import 'dart:ui';
import 'package:chatting/screens/auth_screen.dart';
import 'package:chatting/screens/chat_screen.dart';
import 'package:chatting/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF272D3D),
        accentColor: Color(0xFF48495E),
        buttonColor: Color(0xFF0b8ba3),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx , snapshot) {
          if(snapshot.hasData){
              return HomeScreen();
          }else{
            return SplashScreen();
          }
          }
        ,
      ),
    );
  }
}
