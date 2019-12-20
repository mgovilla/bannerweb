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
  Map<String, int> dayMap = {"M": 0, "T": 1, "W": 2, "R": 3, "F": 4};

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
        });
  }

  Widget scheduleView() {
    List<ScheduleElement> curCourses = List();
    List<List<MaterialButton>> daySched = List(5);
    // Initialize Array
    for(int i = 0; i < 5; i++) {
      daySched[i] = List<MaterialButton>();
    }
    List<Column> days = List(5); // Mon, Tue...

    // Determine which classes are applicable
    for (ScheduleElement course in courses) {
      if (course.start.compareTo(now) <= 0 && course.end.compareTo(now) >= 0) {
        // TODO: check with real date
        curCourses.add(course); // Unused
  
        List<String> activeDays = course.days.split("");
        String btnText = course.courseNum.split(" ")[0] + course.courseNum.split(" ")[1] + "\n" + course.classType + "\n" + course.crn;
        for (String d in activeDays) {
          int index = dayMap[d];
          daySched[index].add(MaterialButton(
            minWidth: MediaQuery.of(context).size.width / 6,
            height: 45,
            padding: EdgeInsets.all(5),
            color: Colors.amber,
            onPressed: () =>_infoDialog(course),
            child: Text(
              btnText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.red
                
              ),
            ),
          ));
        }
      }
    }

    for(int i = 0; i < 5; i++) { // Make sure Magic Wednesday isn't null
      days[i] = Column(
        children: daySched[i],
      );
    }

    // Using current Courses, create the visual schedule
    // For each class
    return RefreshIndicator(
      child: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Row(
                children: days,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
            ),
          )
        ],
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
