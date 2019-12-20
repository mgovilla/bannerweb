import 'src/API.dart';
import 'package:flutter/material.dart';
import 'src/Schedule.dart';

DateTime now = DateTime.utc(2019, 11, 12);

class HomePage extends StatefulWidget {
  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  String classes = "Loading...";
  List<String> choices = ['About', 'Log Out'];
  List<ScheduleElement> courses = List();

  _getClasses() async {
    API.getClasses(user, pin, '202001').then((response) {
      setState(() {
        classes = "";
        for (var s in response) {
          classes += s.toString() + "\n";
        }
        if (classes == "") {
          classes = "Incorrect Credentials";
        } else {
          classes = "";
          courses = response;
        }
      });
    });
  }

  Future<void> _update() async {
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

  void choiceAction(String selection) {
    switch (selection) {
      case "Log Out":
        print("Log Out");
        Navigator.pushNamed(context, "/login_page");
        break;
      case "About":
        break;
      default:
        print('default');
        break;
    }
  }

  void _infoDialog(ScheduleElement course) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Text(course.title),
        );
      }
    );

  }

  Widget scheduleView() {
    List<ScheduleElement> curCourses = List();
    List<RaisedButton> courseNames = List();
    // Determine which classes are applicable
    for (ScheduleElement course in courses) {
      if (course.start.compareTo(now) <= 0 && course.end.compareTo(now) >= 0) {
        // TODO: check with real date
        curCourses.add(course);
        courseNames.add(RaisedButton(
          onPressed: () => _infoDialog(course),
          child: Text(course.toString()),
        ));
      }
    }

    // Using current Courses, create the visual schedule
    // For each class
    return RefreshIndicator(
      child: ListView(
        children: courseNames,
      ),
      onRefresh: _update,
    );
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Schedule"),
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
      body: Column(
        children: <Widget>[
          Container(
            child: scheduleView(),
            height: MediaQuery.of(context).size.height / 1.75,
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
