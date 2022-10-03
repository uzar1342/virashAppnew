import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'globals.dart';

class EmpTask extends StatefulWidget {
   EmpTask({Key? key,required this.emoid,required this.status}) : super(key: key);
   String emoid;
   String status;

  @override
  State<EmpTask> createState() => _EmpTaskState();
}


class check{ //modal class for Person object
  String id;
  check({required this.id});
}



class _EmpTaskState extends State<EmpTask> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  late int check;
  updatetask(taskid) async {
    print(userId);
    var id=[];
    id.add(taskid);
    Dio dio=Dio();
    var formData =
    {
      "emp_id":widget.emoid,
      "completed_task":id,
  };
    print(formData);
    var response = await dio.post('http://training.virash.in/markCompletedTask', data: formData);
    if (response.statusCode == 200) {
      setState(() {

      });
      return response.data;
    } else {
      return response.data;
    }
  }


  bool isLoading=true;
  fetchemployetask() async {
    check=0;
    print(widget.emoid);
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "emp_id":widget.emoid
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/employeeAllTask', data: formData);
    if (response.statusCode == 200) {

      print(response.data["data"]);

      if(response.data["data"]!=null)
      {
        int len=int.parse(response.data["data"].length.toString());
        for(int i=0;i<len;i++)
        {
          if (response.data["data"][i]["status"] == widget.status) {check++;}
        }
      }


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
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body:Container(
          height: employee_role=="Super Admin"||employee_role=="Admin"?h:h*0.8,
          child: RefreshIndicator(
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
                        snapshot.data["data"]!=null&&check>0?ListView.builder(
                        itemCount: snapshot.data["data"].length,
                        itemBuilder: (context, position) {
                          return
                            snapshot.data["data"][position]["status"]==widget.status?
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
                                                    .blue:Colors
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
                                              child: Icon(
                                                Icons
                                                    .person,
                                                color: Colors
                                                    .red.shade200,
                                              )),
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
                                    Row(
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
                                            style: const TextStyle(
                                                color: Colors
                                                    .black54)),
                                      ],
                                    ),
                                  Divider(),
                                    snapshot.data["data"][position]["status"]!="Completed"?Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        employee_role=="Developer & Faculty"||employee_role=="Developer"?Container(
                                          padding:
                                          EdgeInsets.all(8.0),
                                          child:
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title:  const Text('Are you sure?'),
                                                  content:  const Text('Task Completed'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child:  const Text('No'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => {
                                                        Navigator.of(context).pop(false),
                                                        updatetask(snapshot.data["data"][position]["task_id"]),
                                                    setState(() {
                                                    })},
                                                    child:  const Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                               },
                                            child: Container(
                                              padding:
                                              EdgeInsets.all(8.0),
                                              decoration:
                                              BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(
                                                      14.0),
                                                ),
                                              ),
                                              child: Row(children: const [
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  "check",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                )
                                              ]),
                                            ),
                                          ),
                                        ):Container(),
                                      ],
                                    ):Container()
                                  ],
                                ),


                              ),
                            )
                            ):
                            Container();
                        },
                      ):Center(child: Image.asset("assets/no_data.png"));}
                }
              },
            ),
          ),
        )

    );
  }
}
