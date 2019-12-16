import 'src/API.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State {
  String classes = "Loading...";
  String user = '235648495';
  String pin = 'Gathering51';
  List<String> choices = ['Change Login Credentials'];

  _getClasses() {

    API.getClasses(user, pin, '202001').then((response) {
      setState(() {
        
        classes = ""; 
        for(var s in response) {
          classes += s.toString() + "\n";
        }
        if(classes == "") {
          classes = "Incorrect Credentials";
        }
      });
    });
  }

  _update() {
    print('Get Again');
    _getClasses();
  }

  initState() {
    super.initState();
    _getClasses();
  }

  dispose() {
    super.dispose();
  }

  TextEditingController _userController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  _displayDialog(BuildContext context) {
    _userController.clear();
    _pinController.clear();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Login Credentials'),
            content: Container(
              child: Wrap(
                children: <Widget>[
                  TextField(
                    controller: _userController,
                    decoration: InputDecoration(hintText: "Username"),
                  ),
                  TextField(
                    controller: _pinController,
                    decoration: InputDecoration(hintText: "PIN"),
                    obscureText: true,
                    
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('ENTER'),
                onPressed: () {
                  user = _userController.text;
                  pin = _pinController.text;
                  Navigator.of(context).pop();
                  _update();
                },
              )
            ],
          );
        });
  }

  void choiceAction(String selection) {
    switch (selection) {
      case "Change Login Credentials":
        _displayDialog(context);
        break;
      default:
        print('default');
        break;
    }
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HTTP Response"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: new SingleChildScrollView(
                  child: new Text(classes)
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _update,
          child: Icon(Icons.add),
        ),
        );
  }
}