import 'package:Virash/tasknav.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'monthattendence.dart';
import 'virash_app_home_screen.dart';
import 'globals.dart';

class viewemp extends StatefulWidget {
   viewemp({Key? key,required this.type}) : super(key: key);
  String type;

  @override
  State<viewemp> createState() => _viewempState();
}


class _viewempState extends State<viewemp> {
 bool isLoading=true;
 bool net = true;
 var subscription;
 checkinternet() async {

   subscription = Connectivity()
       .onConnectivityChanged
       .listen((ConnectivityResult result) {
     if (result == ConnectivityResult.none) {
       setState(() {
         setState(() {

           net = false;

         });
       });
     } else {
       setState(() {
         net = true;
       });
     }
   });
 }

  fetchemployelist() async {
    print(userId);
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "emp_id":userId
    });
print(formData.fields);
    var response = await dio.post('http://training.virash.in/employee_list', data: formData);
    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
      setState(() {
        isLoading = false;
      });
    } else {
      return response.data;
      Fluttertoast.showToast(msg: "Unable to fetch bank list");
      setState(() {
        isLoading = false;
      });
    }
  }
@override
  void initState() {
  checkinternet();
  fetchemployelist();
    super.initState();
  }
 @override
 void dispose() {
   subscription.cancel;
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
   var h=MediaQuery.of(context).size.height;
   var w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title:Text("VIEW EMPLOYE")),
      body:net?FutureBuilder<dynamic>(
        future: fetchemployelist(), // async work
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return SafeArea(child:Text('Error: ${snapshot.error}'));
              } else {
                Color primaryColor = const Color(0xff1f7396);
                return   snapshot.data["success"].toString().trim()=="1"?
                Container(
                  height: h*0.8,
                  child: ListView.builder(
                    itemCount: snapshot.data["data"].length,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, position) {
                      return
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                          onTap:()=>{

                            },
                          child: Card(
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)
                            ),
                            elevation: 5,
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(snapshot.data["data"][position]["emp_name"]),
                              trailing: PopupMenuButton<int>(
                                icon: Container(child:Icon(Icons.more_vert)),
                                itemBuilder: (context) => [
                                  // PopupMenuItem 1
                                  PopupMenuItem(
                                    value: 1,
                                    // row with 2 children
                                    child: Row(
                                      children: [
                                        Icon(Icons.task),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Add Task")
                                      ],
                                    ),
                                  ),
                                  // PopupMenuItem 2
                                  PopupMenuItem(
                                    value: 2,
                                    // row with two children
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Monthly Status")
                                      ],
                                    ),
                                  ),
                                ],
                                offset: Offset(0, 40),
                                color: Colors.white,
                                elevation: 2,
                                // on selected we show the dialog box
                                onSelected: (value) {
                                  // if value 1 show dialog
                                  if (value == 1) {
                                    Navigator.push(context, MaterialPageRoute(builder: (c)=>
                                        TaskNav(id: snapshot.data["data"][position]["emp_id"].toString(),)));
                                    // if value 2 show dialog
                                  } else if (value == 2) {
                                      Navigator.push(context, MaterialPageRoute(builder: (c)=>
                                          MonthCalendarPage(name: snapshot.data["data"][position]["emp_name"].toString(), id: snapshot.data["data"][position]["emp_id"].toString(),))
                                      );
                                  }
                                },
                              ),
                            ),
                          ),
                      ),
                        );


                    },
                  ),
                ):Image.asset("assets/no_data.png");
              }
          }
        },
      ):SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/no_internet.png",
                height: 300,
                width: 300,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  "Looks like you got disconnected, Please check your Internet connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ))

    );
  }
}
