import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'Messages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Facts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FlutterFactsChatBot(title: 'CHATBOT',),
    );
  }
}

