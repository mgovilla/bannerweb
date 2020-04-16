import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/src/API.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  bool loadHome;

  Future<bool> _rememberedCredentials() async {
    String tUser = await storage.read(key: "user");
    String tPin = await storage.read(key: "pin");

    if (tUser != null || tPin != null) {
      user = tUser;
      pin = tPin;
      return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    _rememberedCredentials().then((response) {
      setState(() {
        loadHome = response;
      });
    });
  }

  @override
  build(context) {
    if (loadHome == null) {
      return Container();
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WPI Bannerweb',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: loadHome ? HomePage() : LoginPage(),
        routes: {
          '/home_page': (context) => HomePage(),
          '/login_page': (context) => LoginPage(),
          //'/info_page': (context) => InfoPage(),
        },
      );
    }
  }
}
