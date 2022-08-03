import 'dart:async';
import 'package:Virash/shared_prefs_keys.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitness_app_home_screen.dart';
import 'globals.dart';
import 'login.dart';
import 'mark_attendence.dart';
void main() {
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}




class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool isUserLoggedIn = false;
checkinternet() async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    getUserLogginStatus();
    timer();
  } else {
    Fluttertoast.showToast(msg: "No Internet");
  }
}
  getUserLogginStatus() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = _prefs.getBool(isUserLoggedInKey) ?? false;
      userId = _prefs.getString(userIdKey) ?? '';
      attendence=_prefs.getBool(Userattendence) ?? false;
      employee_role=_prefs.getString(Userrole) ?? "";
      employee_name=_prefs.getString(Username) ?? "";
      print("IS USER LOGGED IN: $isUserLoggedIn");
      print(" USER ID: $userId");
      print(" Attendence: $attendence");
      print(" role: $employee_role");


    });
  }
  @override
  void initState() {

    checkinternet();
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:Image.asset("assets/logo-withoutBG.png")
    );
  }

  acess()
  async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'emp_id': userId,
    });
    final url = Uri.parse('http://training.virash.in/check_access');
    var response = await dio.post(url.toString(), data: formData);
    if(response.statusCode==200)
      {
        String jsonsDataString = response.data.toString();
        List as=jsonsDataString.split(",");
        String sucess=as[0].toString().split(":").last.toString();
        print(sucess);
        if(sucess.trim()=="1")
          {
            check();
          }
        else
          {
            Fluttertoast.showToast(msg: "Acess Dineid");
          }

      }
    }

  check()
  {

    if(isUserLoggedIn)
      {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
          (context) =>
              FitnessAppHomeScreen()
              ));
      }
      else
        {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
                      HomePage()));
        }
  }


  Future<void> timer() async {

    Timer(Duration(seconds: 2),
            (){
              if(userId!="")
                {
                  acess();
                }
              else
                {
                  check();
                }

            }

           // TakePictureScreen(camera: firstCamera,)

    );

  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
