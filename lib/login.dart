import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homescreen/shared_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitness_app_home_screen.dart';
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {




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
                      InkWell(
                        onTap: () {
                          if(Emailcon.value.text!=""&&passcon.value.text!="")
                            {
                              login(Emailcon.value.text,passcon.value.text);
                            }
                          else
                            {
                              Fluttertoast.showToast(msg: "Fill credincel");
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

  Future<void> login(String Email, String pass) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Dio dio=new Dio();
    var formData = FormData.fromMap({
      'username': Email,
      'password': pass,
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/auth-user', data: formData);
    if(response.statusCode==200)
      {
        String jsonsDataString = response.data.toString();
        List as=jsonsDataString.split(",");
        print(as[0].toString().split(":").last.toString());
        String sucess=as[0].toString().split(":").last.toString();
       // print(as[2].toString().split(":").last.toString());
        if(sucess.trim()=="1")
          {
           _prefs.setString(userIdKey,as[2].toString().split(":").last.toString());
           _prefs.setBool(isUserLoggedInKey,true);
           Navigator.pushReplacement(context,
               MaterialPageRoute(builder:
                   (context) =>
                   FitnessAppHomeScreen()
               )
           );
          }
        else{
          Fluttertoast.showToast(msg: "Login Fail");
        }


      }
    else
      {



        print(response.statusCode);
      }

  }
}