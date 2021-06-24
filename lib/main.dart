import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telegrammm/screens/loading.dart';
import 'package:telegrammm/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return MaterialApp(
            title: 'Telegram Replica',
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: LoginScreen(),
          );
        else
          return Loading();
      },
    );
  }
}
