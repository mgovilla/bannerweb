import 'package:flutter/material.dart';
import 'src/API.dart';

class LoginPage extends StatefulWidget {

  @override
  createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _userController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    
    final userField = TextField(
      obscureText: false,
      controller: _userController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      controller: _pinController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xffc41230),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: submitCredentials,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final rememberMe = CheckboxListTile(
        checkColor: Color(0xffc41230),
        controlAffinity: ListTileControlAffinity.leading,
        value: _rememberMe,
        onChanged: (newValue){
          setState(() {
            _rememberMe = newValue;
          });
        },
        title: Text("Remember me", style: style,),
      );

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(36.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 250.0,
                  child: Image.asset(
                    "images/logo.png", // Takes a long time to load for some reason (large?)
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 40.0),
                userField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 10.0),
                rememberMe,
                SizedBox(height: 25.0),
                loginButon,
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitCredentials() {
    user = _userController.text;
    pin = _pinController.text;
    
    if(_rememberMe) {
      storage.write(key: "user", value:user);
      storage.write(key: "pin", value:pin);
    }
    
    
    Navigator.popAndPushNamed(context, "/home_page");
  }
}
