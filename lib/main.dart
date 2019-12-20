import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Http App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginPage(),
      routes: {
        '/home_page' : (context) => HomePage(),
        '/login_page': (context) => LoginPage(),
        //'/info_page': (context) => InfoPage(),

      },
    );
  }
}

