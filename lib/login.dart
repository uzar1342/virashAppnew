import 'package:Virash/shared_prefs_keys.dart';
import 'package:dio/dio.dart'as di;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:dio/src/form_data.dart' as f;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'virash_app_home_screen.dart';
import 'globals.dart';
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool net = false;



  checkinternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      net=true;
    } else {
      net=false;
      Fluttertoast.showToast(msg: "No Internet");
    }
  }
@override
  void initState() {
    checkinternet();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController Emailcon=TextEditingController();
    TextEditingController passcon=TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child:  Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/light-1.png')
                                )
                            ),
                          ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child:  Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child:  Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        ),
                      ),
                      Positioned(
                        child:  Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey))
                              ),
                              child: TextField(
                                controller: Emailcon,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email or Phone number",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: true,
                                controller: passcon,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      isLoading ?Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: primaryColor,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ):InkWell(
                        onTap: () {
                          if(net==true)
                            {
                              if(Emailcon.value.text!=""&&passcon.value.text!="")
                              {
                                setState(() {
                                  isLoading=true;
                                });
                                login(Emailcon.value.text,passcon.value.text);
                              }
                              else
                              {
                                Fluttertoast.showToast(msg: "Fill credincel");
                              }

                            }
                          else
                            {
                              Fluttertoast.showToast(msg: "No Internet");
                            }

                        } ,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, .6),
                                  ]
                              )
                          ),
                          child: Center(
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      SizedBox(height: 70,),
                      Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


  acess()
  async {
    Dio dio=Dio();
    var formData = f.FormData.fromMap({
      'emp_id': userId,
    });
    final url = Uri.parse('http://training.virash.in/check_access');
    var response = await dio.post(url.toString(), data: formData);
    if(response.statusCode==200)
    {
      String jsonsDataString = response.data.toString();
      List as=jsonsDataString.split(",");
      String sucess=response.data["success"];
      print(sucess);
      if(sucess.trim()=="1")
      {
        attendence=response.data["attendance_flag"].toString().trim();
        print(attendence);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                VirashAppHomeScreen()
            )
        );
      }
      else
      {
        Fluttertoast.showToast(msg: "Acess Dineid");
      }

    }
  }

  Future<void> login(String Email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio=Dio();
    var formData = di.FormData.fromMap({
      'username': Email,
      'password': pass,
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/auth-user', data:formData);
    if(response.statusCode==200)
      {
        print(response.data["data"]["employee_id"]);
        String jsonsDataString = response.data.toString();
        if(response.data["success"].trim()=="1")
          {
            setState(() {
              isLoading=false;
            });
        //   prefs.setString(userIdKey,data2);
           prefs.setString(Username,response.data["data"]["employee_name"].toString());
           prefs.setString(Userrole,response.data["data"]["employee_role"]);
           prefs.setString(userIdKey,response.data["data"]["employee_id"].toString());
           prefs.setBool(isUserLoggedInKey,true);
            employee_role=prefs.getString(Userrole) ?? "";
            employee_name=prefs.getString(Username) ?? "";
            userId = prefs.getString(userIdKey) ?? '';


            acess();

          }
        else{
          setState(() {
            isLoading=false;
          });
          Fluttertoast.showToast(msg: "Login Fail");
        }


      }
    else
      {
        setState(() {
          isLoading=false;
        });
        print(response.headers.printError);
      }

  }
}