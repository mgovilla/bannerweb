import 'dart:async';
import 'dart:io';
import 'Schedule.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseURL = 'https://bannerweb.wpi.edu';
const url = 'https://bannerweb.wpi.edu/pls/prod/twbkwbis.P_ValLogin';
const detlURL = 'https://bannerweb.wpi.edu/pls/prod/bwskfshd.P_CrseSchdDetl';

final storage = new FlutterSecureStorage();

String user;
String pin;

class API {
  
  static Future<List> getClasses(String user, String pin, String term) async {
    Map<String, String> data = {
      'sid': user,
      'pin': pin
    };

    Map<String, String> headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:70.0) Gecko/20100101 Firefox/70.0'
    };

    var response = await http.post(url, headers: headers, body: data); // Getting the cookies set from bannerweb 
    var cookie = response.headers['set-cookie'];
    headers['Cookie'] = cookie;                                        // Necessary to start the login

    var login = await http.post(url, body:data, headers:headers);      // Login (again because thats how bannerweb works)
    var temp = login.headers['set-cookie'].split(",");                 // Get the session ID and other cookies
    
    headers['Cookie'] = 'TESTID=set' + ';' + temp[0] + ';' + temp[1].split(";")[0] + ';' + temp[2].split(";")[0];
    
    Map<String, String> tempBody = {
      'term_in': term,
    };

    var scheduleHtml = await http.post(detlURL, headers: headers, body: tempBody);
    var parsedSchedule = html.parse(scheduleHtml.body);
    var list = parsedSchedule.getElementsByClassName("datadisplaytable");

    return makeSchedule(list);
  }
}