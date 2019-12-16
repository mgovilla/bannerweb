import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'dart:core';

List makeSchedule(List<Element> document) {
  var ddtable = document;
  List<ScheduleElement> courses = new List();

   //loop through tables
  for (var i = 0; i < ddtable.length; i += 2) {
    // Data is stored in pairs of elements
    var infoTable = ddtable[i];

    // Class names
    var className = infoTable.children[0].text;
    var nameParts = className.split(" - ");
    var title = nameParts[0];
    var course = nameParts[1] + " " + nameParts[2];

    // Descriptions
    var description = infoTable.children[1].text.split("\n");
    description.removeWhere(
        (string) => string == ""); // Clean the array, but not exactly necessary
    var crn = description[description.indexOf("CRN:") + 1];

    // Schedule Portion
    var schedule = ddtable[i + 1];
    var classes = schedule.children[1];

    for (var j = 1; j < classes.children.length; j++) {
      // The table will have information about every part (lecture/conference)
      var classInfo = classes.children[j];
      var times = classInfo.children[1].text.split(" - ");
      var days = classInfo.children[2].text;
      var location = classInfo.children[3].text;
      var dates = classInfo.children[4].text.split(" - ");
      var classType = classInfo.children[5].text;
      var instructor = classInfo.children[6].text.trim(); // Check TBA

      DateFormat format1 = new DateFormat("MMM dd, yyyy");
      DateTime startDate = format1.parse(dates[0]);
      DateTime endDate = format1.parse(dates[1]);

      DateFormat format2 = new DateFormat("h:mm a");
      DateTime startTime = format2.parse(times[0].toUpperCase());
      DateTime endTime = format2.parse(times[1].toUpperCase());

      courses.add(new ScheduleElement(title, classType, crn, course, instructor, startDate, endDate, location, startTime, endTime, days));
    }
  }
  return courses;
}

class ScheduleElement extends Object {
  String title, classType, crn, courseNum, instructor, location, days;
  DateTime start, end, startTime, endTime; 

  ScheduleElement(String title, String classType, String crn, String courseNum, String instructor, DateTime start, DateTime end, String location, DateTime startTime, DateTime endTime, String days) {
    this.title = title;
    this.classType = classType;
    this.courseNum = courseNum;
    this.instructor = instructor;
    this.location = location;

    this.start = start;
    this.end = end;
    this.startTime = startTime;
    this.endTime = endTime;
  }

  @override
  String toString() {
    return "$title $courseNum with $instructor";
  }

}