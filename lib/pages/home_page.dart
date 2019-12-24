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
  int schStartTime;
  int schEndTime; 
  double block;
  TextStyle schStyle = TextStyle(fontSize: 10, color: Colors.red);

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

  Positioned classButton(ScheduleElement course, String btnText) {
    
    return Positioned(
      top: (course.startTime.hour - schStartTime) * block,
      height: (course.endTime.hour - course.startTime.hour + 1)*block - block/6,
      child: (MaterialButton(
        color: Colors.amber,
        onPressed: () => _infoDialog(course),
        minWidth: 11*MediaQuery.of(context).size.width / 60 - 4,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Text(
          btnText,
          textAlign: TextAlign.center,
          style: schStyle,
        ),
      )),
    );
  }

  Widget scheduleView() {
    schStartTime = 12;
    schEndTime = 12;
    List<ScheduleElement> curCourses = List();
    List<List<Positioned>> daySched = List(5);
    // Initialize Array
    for (int i = 0; i < 5; i++) {
      daySched[i] = List<Positioned>();
    }
    List<Container> days = List(5); // Mon, Tue...

    // Determine which classes are applicable
    for (ScheduleElement course in courses) {
      if (course.start.compareTo(now) <= 0 && course.end.compareTo(now) >= 0) {
        // TODO: check with real date
        curCourses.add(course); // Unused

        if (course.startTime.hour < schStartTime) {
          schStartTime = course.startTime.hour;
        }

        if (course.endTime.hour > schEndTime) {
          schEndTime = course.endTime.hour;
        }

      }
    }

    for(ScheduleElement course in curCourses) {
      List<String> activeDays = course.days.split("");
        String btnText = course.courseNum.split(" ")[0] +
            course.courseNum.split(" ")[1] +
            "\n" +
            course.classType +
            "\n" +
            course.crn;
        for (String d in activeDays) {
          int index = dayMap[d];
          daySched[index].add(classButton(course, btnText));
        }
    }

    for (int i = 0; i < 5; i++) {
      // TODO: Make sure Magic Wednesday isn't null
      days[i] = Container(
        child: Stack(
          children: daySched[i],
        ),
        width: 11*MediaQuery.of(context).size.width / 60 - 4,
        height: block*(schEndTime - schStartTime + 1),
      );
    }

    List<TableRow> shadeRows = new List(schEndTime - schStartTime + 1);
    for(int i = 0; i < shadeRows.length; i++) {
      shadeRows[i] = TableRow(
          children: <Widget>[
            SizedBox (
              child: Text("${i+schStartTime}"), 
              height: block,
            )
          ],
          decoration: BoxDecoration(color: i%2 == 0 ? Color(0xffededed): Colors.white, border: Border(top: BorderSide(color: Colors.grey)))
        );
    }
    // Using current Courses, create the visual schedule
    // For each class
    return RefreshIndicator(
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Table(
                children: shadeRows,
              ),
              Container(
                child: Row(
                  children: days,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 12, 0, 0, 0),
              ),
            ],
          )
        ],
      ),
      onRefresh: _update,
    );
  }

  @override
  build(context) {
    block = MediaQuery.of(context).size.height / 16;

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
            height: block*(schEndTime - schStartTime + 1),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
