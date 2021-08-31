import 'package:flutter/material.dart';
import 'package:itgroup/pages/login.dart';
import 'package:itgroup/pages/home.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/home': (context) => Home()
      },
    );
  }
}