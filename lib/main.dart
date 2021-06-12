import 'package:flutter/material.dart';
import 'package:telegrammm/screens/chats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Replica',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        //primaryColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChatCatalog(),
    );
  }
}



