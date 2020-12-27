import 'package:flutter/material.dart';
import 'package:sales/components/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tron Sales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      // MyHomePage(title: 'Tron Sales Online'),
    );
  }
}
