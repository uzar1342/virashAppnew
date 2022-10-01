import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'globals.dart';

class AllEmpTask extends StatefulWidget {
  AllEmpTask({Key? key,required this.emoid}) : super(key: key);
  String emoid;


  @override
  State<AllEmpTask> createState() => _AllEmpTaskState();
}


class check{ //modal class for Person object
  String id;
  check({required this.id});
}



class _AllEmpTaskState extends State<AllEmpTask> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  late int check;



  bool isLoading=true;
  fetchemployetask() async {
    check=0;
    print(widget.emoid);
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "emp_id":"3"
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/allEmployeeTodaysTask', data: formData);
    if (response.statusCode == 200) {

      print(response.data["data"]);




      print(check);

      print(response.data);
      return response.data;
    } else {
      Fluttertoast.showToast(msg: "Unable to fetch bank list");
      setState(() {
        isLoading = false;
      });
      return response.data;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text("VIEW EMPLOYEE")),
        body:RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.blue,
          strokeWidth: 4.0,
          onRefresh: () async {
            _refreshIndicatorKey.currentState?.show(); setState(() {
            });
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: FutureBuilder<dynamic>(
            future: fetchemployetask(), // async work
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return SafeArea(child:Text('Error: ${snapshot.error}'));
                  } else {
                    print("object");
                    var w=MediaQuery.of(context).size.width;
                    var h=MediaQuery.of(context).size.height;
                    Color primaryColor = const Color(0xff1f7396);
                    return
                      snapshot.data["data"]!=null?ListView.builder(
                        itemCount: snapshot.data["data"].length,
                        itemBuilder: (context, position) {
                          return
                            InkWell(
                                onTap:()=>{
                                },
                                child:
                                Container(
                                  width: w,
                                  margin: const EdgeInsets.all(5.0),
                                  child: Card(
                                    elevation: 3.0,
                                    shape:  RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))),
                                    child:            Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              children: [

                                                SizedBox(
                                                  width: w * 0.02,
                                                ),
                                                Text(
                                                  snapshot.data["data"][position]["emp_name"].toString(),
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .black54,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: 16.0),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: (){


                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets
                                                    .all(5.0),
                                                height: h * 0.04,
                                                decoration:
                                                BoxDecoration(
                                                    color: snapshot.data["data"][position]["priority"]=="high"?
                                                    Colors
                                                        .red:snapshot.data["data"][position]["priority"]=="medium"?Colors
                                                        .yellow:Colors
                                                        .green,
                                                    borderRadius: const BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        20.0))),
                                                child: Row(
                                                  children: [
                                                    const FaIcon(
                                                      FontAwesomeIcons
                                                          .globe,
                                                      color: Colors
                                                          .white,
                                                      size: 20.0,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                      w * 0.01,
                                                    ),
                                                    Text(
                                                      snapshot.data["data"][position]["priority"].toString(),
                                                      style: const TextStyle(
                                                          color:
                                                          Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .date_range_sharp,
                                                  color: Colors
                                                      .green.shade200,
                                                ),
                                                SizedBox(
                                                  width: w * 0.01,
                                                ),
                                                Text(

                                                    snapshot.data["data"][position]["assigned_date"],
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .black54)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .access_time_filled,
                                                  color: Colors
                                                      .red.shade200,
                                                ),
                                                SizedBox(
                                                  width: w * 0.01,
                                                ),
                                                Text(
                                                    snapshot.data["data"][position]["assigned_time"].toString(),
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .black54)),
                                              ],
                                            )
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .assignment,
                                              color: Colors
                                                  .red.shade200,
                                            ),
                                            SizedBox(
                                              width: w * 0.01,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  snapshot.data["data"][position]["task"]!=null?snapshot.data["data"][position]["task"].toString():"",
                                                  maxLines: 8,style: const TextStyle(
                                                  color: Colors
                                                      .black54)),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: SizedBox(
                                                  height: 24 ,
                                                  width: 24,
                                                  child: Image.asset("assets/assignment.png",)),
                                            )
                                            ,
                                            SizedBox(
                                              width: w * 0.01,
                                            ),
                                            Text(
                                                snapshot.data["data"][position]["assigned_by"],
                                                style: const TextStyle(
                                                    color: Colors
                                                        .black54)),
                                          ],
                                        ),
                                        Divider(),
                                        Container(
                                          color: snapshot.data["data"][position]["status"]=="Completed"?
                                          Color(0xFF91b7ed):snapshot.data["data"][position]["status"]=="Pending"?Color(0xFFedc791):
                                          snapshot.data["data"][position]["status"]=="Rejected"?Color(0xFFed9c91):Color(0xff91edbf),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .pending_actions,
                                                color: Colors
                                                    .red.shade200,
                                              )
                                              ,
                                              SizedBox(
                                                width: w * 0.01,
                                              ),
                                              Text(
                                                  snapshot.data["data"][position]["status"],
                                                  style:  TextStyle(
                                                      color:snapshot.data["data"][position]["status"]=="Completed"?Color(0xFF0e1163):snapshot.data["data"][position]["status"]=="Pending"?Color(0xFF63400e):
                                                      snapshot.data["data"][position]["status"]=="Rejected"?Color(0xFF63190e):Color(0xff0e6339)
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),


                                  ),
                                )
                            );

                        },
                      ):Center(child: Image.asset("assets/no_data.png"));}
              }
            },
          ),
        )

    );
  }
}
