import 'dart:convert';
import 'dart:developer';
import 'package:Virash/taskimg.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;

class ApprovedTask extends StatefulWidget {
  ApprovedTask( {Key? key,required this.emoid,required this.name}) : super(key: key);
  String emoid,name;
  @override
  State<ApprovedTask> createState() => _ApprovedTaskState();
}
class check{ //modal class for Person object
  String id;
  check({required this.id});
}

List<String> approveid=[];
var rejectid=[];


class _ApprovedTaskState extends State<ApprovedTask> {
  late int check;
  approvtask(taskid) async {
    print(userId);
    setState(() {
    });
    var id=[];
    id.add(taskid);
    Dio dio=Dio();
    var formData =
    {
      "admin_id":userId,
      "emp_id":widget.emoid,
      "approved_task":id,
      "rejected_task":[]
    };
    print(formData);
    var response = await dio.post('http://training.virash.in/acknowledgeTask', data: formData);
    if (response.statusCode == 200) {
      setState(() {

      });
      return response.data;
    } else {
      setState(() {
      });
      return response.data;
    }
  }

  rejtask(taskid, remark) async {
    print(userId);
    setState(() {

    });
    var id=[];
    id.add({"id":taskid,"remark":remark!=""?remark:""});
    Dio dio=Dio();
    var formData =
    {
      "admin_id":userId,
      "emp_id":widget.emoid,
      "approved_task":[],
      "rejected_task":id
    };
    print(formData);
    var response = await dio.post('http://training.virash.in/acknowledgeTask', data: formData);
    if (response.statusCode == 200) {
      setState(() {

      });
      return response.data;
    } else {
      setState(() {

      });
      return response.data;
    }
  }


  multichecktask(rejid, appid) async {
    setState(() {

    });
    var id=rejid;
    print(id);
  var df=json.encode({"admin_id": "3", "emp_id": "5", "approved_task": appid, "rejected_task": rejid});
  print(df);
    final url = Uri.parse('http://training.virash.in/acknowledgeTask');
    http.Response response = await http.post(
      url,
      body: df,
    );
    Map mapRes = json.decode(response.body);
    print(mapRes);
    print(response.statusCode);
    // Dio dio=Dio();
    // var formData =
    // {
    //   "admin_id":userId,
    //   "emp_id":widget.emoid,
    //   "approved_task":appid,
    //   "rejected_task":rejid
    // };
    // print(formData);
    // var response = await dio.post('http://training.virash.in/acknowledgeTask', data: formData);
    if (response.statusCode == 200) {



      final snackBar = SnackBar(
        content:  Text(mapRes.values.last),
        backgroundColor: (primaryColor),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);





      setState(() {
      });

    } else {
      final snackBar = SnackBar(
        content:  Text(mapRes.values.last.toString()),
        backgroundColor: (primaryColor),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {

      });
    }
  }
  fetchemployetask() async {
    check=0;
    print(widget.emoid);
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "admin_id":userId,
      "emp_id":widget.emoid
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/employeeWiseAllCompletedTaskForApproval', data: formData);
    if (response.statusCode == 200) {
      print(response.data["data"]);
      print(check);
      int len=int.parse(response.data["data"].length.toString());
      approveid.clear();
      rejectid.clear();
      for(int i=0;i<len;i++)
        {
          approveid.add("");
          rejectid.add("");
        }
      print(response.data);
      return response.data;
    }
    else {
      Fluttertoast.showToast(msg: "Unable to fetch bank list");
      setState(() {

      });
      return response.data;
    }
  }
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  TextEditingController remark=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body:LoaderOverlay(
          child: SafeArea(
            child: RefreshIndicator(
                key: _refreshIndicatorKey,
                color: Colors.white,
                backgroundColor: Colors.blue,
                strokeWidth: 4.0,
                onRefresh: () async {
                  return setState(() {
                  });
                },
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      height: h * 0.09,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  widget.name,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  var appid=[];
                                  approveid.forEach((element) {
                                    if(element.trim()!="")
                                    {
                                      appid.add(element);
                                    }
                                  });
                                  var rejid=[];
                                  rejectid.forEach((element) {
                                    if(element!="")
                                    {
                                      rejid.add(element);
                                    }
                                  });
                                  log(appid.toString());
                                    if(appid.isNotEmpty||rejid.isNotEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: new Text('Are you sure?'),
                                          content: new Text('Do you want Approve/Reject Task'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: new Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () => {
                                                Navigator.of(context).pop(false),
                                                print(appid),
                                                print(rejid),
                                                multichecktask(rejid,appid)
                                              },
                                              child: new Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );


                                  }
                                  else
                                  {
                                    final snackBar = SnackBar(
                                      content: const Text('Fill Task'),
                                      backgroundColor: (primaryColor),
                                      action: SnackBarAction(
                                        label: 'dismiss',
                                        onPressed: () {
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                },icon: const Icon(Icons.send),
                              ),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                    flex: 9,
                    child: Container(
                      child: FutureBuilder<dynamic>(
                        future: fetchemployetask(), // async work
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError) {
                                return SafeArea(
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors
                                          .white,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "asset/somthing_went_wrong.png",
                                            height: 300,
                                            width: 300,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                                            child: const Text(
                                              "somthing went wrong",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              } else {
                                print("object");
                                var w=MediaQuery.of(context).size.width;
                                var h=MediaQuery.of(context).size.height;
                                Color primaryColor = const Color(0xff1f7396);
                                return
                                  snapshot.data["data"]!=null?Container(
                                    child:snapshot.data["data"].length>0?ListView.builder(
                                      itemCount: snapshot.data["data"].length,
                                      itemBuilder: (context, position) {
                                        return
                                          snapshot.data["data"][position]["status"]!="Pending"?
                                          Card(
                                            elevation: 3.0,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14.0))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                content: InkWell(
                                                                    onTap:()=>{
                                                                    },
                                                                    child:
                                                                    Container(
                                                                    width: w,
                                                                      height: h*0.5,
                                                                      margin: const EdgeInsets.all(5.0),
                                                                      child: Column(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 3,
                                                                                child: Row(
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


                                                                                    // Expanded(
                                                                                    //   child: Container(
                                                                                    //     child: RichText(
                                                                                    //       overflow: TextOverflow.ellipsis,
                                                                                    //       strutStyle: StrutStyle(fontSize: 17.0),
                                                                                    //       text: TextSpan(
                                                                                    //           style:  const TextStyle(
                                                                                    //               color: Colors.black87,
                                                                                    //               fontWeight:
                                                                                    //               FontWeight.bold,
                                                                                    //               fontSize: 20
                                                                                    //           ),
                                                                                    //           text: snapshot.data["data"][position]["emp_name"].toString()),
                                                                                    //     ),
                                                                                    //   ),
                                                                                    // )



                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 2,
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
                                                                                        snapshot.data["data"][position]["priority"].toString().trim(),
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

                                                                                      snapshot.data["data"][position]["date_assigned"]!=null?snapshot.data["data"][position]["date_assigned"].toString():"N/A",
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

                                                                                      snapshot.data["data"][position]["time_assigned"].toString(),
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
                                                                              Container(
                                                                                width: w*0.5,
                                                                                child: Text(
                                                                                    snapshot.data["data"][position]["task"]!=null?snapshot.data["data"][position]["task"].toString():"",
                                                                                    maxLines: 8,
                                                                                    style: const TextStyle(
                                                                                        color: Colors
                                                                                            .black54)),
                                                                              ),
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

                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  padding:
                                                                                  EdgeInsets.all(8.0),
                                                                                  child:
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) => AlertDialog(
                                                                                          title:  const Text('Are you sure?'),
                                                                                          content:  const Text('Do you want to approve this task'),
                                                                                          actions: <Widget>[
                                                                                            TextButton(
                                                                                              onPressed: () => Navigator.of(context).pop(false),
                                                                                              child:  const Text('No'),
                                                                                            ),
                                                                                            TextButton(
                                                                                              onPressed: () => {
                                                                                                Navigator.of(context).pop(false),
                                                                                                approvtask(snapshot.data["data"][position]["task_id"]),
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
                                                                                      EdgeInsets.all(9.0),
                                                                                      decoration:
                                                                                      BoxDecoration(
                                                                                        color: primaryColor,
                                                                                        borderRadius:
                                                                                        const BorderRadius.all(
                                                                                          Radius.circular(
                                                                                              14.0),
                                                                                        ),
                                                                                      ),
                                                                                      child: Row(children:  const [
                                                                                        Icon(
                                                                                          Icons.check,
                                                                                          color: Colors.white,
                                                                                        size: 18,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 3.0,
                                                                                        ),
                                                                                        Text(
                                                                                          "Approved Task",
                                                                                          style: TextStyle(
                                                                                            fontSize: 8,
                                                                                              color: Colors
                                                                                                  .white,
                                                                                              fontWeight:
                                                                                              FontWeight
                                                                                                  .bold),
                                                                                        )
                                                                                      ]),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  padding:
                                                                                  EdgeInsets.all(8.0),
                                                                                  child:
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            title: Text(
                                                                                              "Complete Task",
                                                                                              style: TextStyle(
                                                                                                  color: primaryColor,
                                                                                                  fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            content: Container(
                                                                                              height: h*0.4,
                                                                                              child: Scaffold(
                                                                                                resizeToAvoidBottomInset:false,
                                                                                                body: Form(
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      Text("Please fill Remark",
                                                                                                          style: TextStyle(
                                                                                                              color: Colors.black54,
                                                                                                              fontWeight: FontWeight.bold)),
                                                                                                      SizedBox(
                                                                                                        height: h * 0.01,
                                                                                                      ),
                                                                                                      Container(
                                                                                                        //  height: h * 0.07,
                                                                                                        width: w * 0.95,
                                                                                                        child: Card(
                                                                                                          elevation: 3.0,
                                                                                                          child: TextFormField(
                                                                                                            controller: remark,
                                                                                                            maxLines: 8,
                                                                                                            cursorColor: primaryColor,
                                                                                                            decoration: InputDecoration(
                                                                                                                suffixIcon: Icon(
                                                                                                                  Icons.assignment,
                                                                                                                  color: Colors.red.shade200,
                                                                                                                ),
                                                                                                                hintText: "2,3 Done",
                                                                                                                hintStyle: const TextStyle(
                                                                                                                  color: Colors.black26,
                                                                                                                  fontWeight: FontWeight.bold,
                                                                                                                  fontSize: 14.0,
                                                                                                                ),
                                                                                                                filled: true,
                                                                                                                fillColor: Colors.white,
                                                                                                                border: OutlineInputBorder(
                                                                                                                  gapPadding: 9,
                                                                                                                  borderSide: BorderSide.none,
                                                                                                                  borderRadius: BorderRadius.all(
                                                                                                                      Radius.circular(12.0)),
                                                                                                                ),
                                                                                                                contentPadding:
                                                                                                                EdgeInsets.symmetric(
                                                                                                                    horizontal: 20.0,
                                                                                                                    vertical: 16.0)),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: h * 0.04,
                                                                                                      ),
                                                                                                      Row(
                                                                                                        mainAxisAlignment:
                                                                                                        MainAxisAlignment.spaceBetween,
                                                                                                        children: [
                                                                                                          TextButton(
                                                                                                            onPressed: () {
                                                                                                              Navigator.pop(context);
                                                                                                            },
                                                                                                            child: const Text(
                                                                                                              "Cancel",
                                                                                                              style: TextStyle(
                                                                                                                color: Colors.black54,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                decoration:
                                                                                                                TextDecoration.underline,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          InkWell(
                                                                                                            onTap: ()  {
                                                                                                              Navigator.pop(context);
                                                                                                              rejtask(snapshot.data["data"][position]["task_id"],remark.value.text);
                                                                                                              setState(() {
                                                                                                              });

                                                                                                            },
                                                                                                            child: Container(
                                                                                                              height: h * 0.04,
                                                                                                              padding: const EdgeInsets.symmetric(
                                                                                                                  horizontal: 10.0),
                                                                                                              decoration: BoxDecoration(
                                                                                                                  borderRadius: const BorderRadius.all(
                                                                                                                    Radius.circular(6.0),
                                                                                                                  ),
                                                                                                                  color: primaryColor),
                                                                                                              child: const Center(
                                                                                                                child: Text(
                                                                                                                  "Apply",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors.white,
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                      fontSize: 15.0),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ));





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
                                                                                          Icons.cancel,
                                                                                          color: Colors.white,
                                                                                          size: 18,
                                                                                        ),

                                                                                        SizedBox(width: 5.0,),
                                                                                        Text(
                                                                                          "Reject Task",
                                                                                          style: TextStyle(
                                                                                              color: Colors
                                                                                                  .white,
                                                                                              fontSize: 8,
                                                                                              fontWeight:
                                                                                              FontWeight
                                                                                                  .bold),
                                                                                        )
                                                                                      ]),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )



                                                                )
                                                                ,
                                                              ));

                                                        },
                                                        child: Row(
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
                                                            Container(
                                                              width: w*0.4,
                                                              child: Text(
                                                                  snapshot.data["data"][position]["task"]!=null?snapshot.data["data"][position]["task"].toString():"",
                                                                  maxLines: 8,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black54)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Row(
                                                        children: [
                                                          snapshot.data["data"][position]["task_img"]!="N/A"?Expanded(
                                                            flex: 1,
                                                            child: GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(context, MaterialPageRoute(builder: (c)=>Taskimg(img:  snapshot.data["data"][position]["task_img"],)));
                                                              },
                                                              child: Container(
                                                                width: 30,
                                                                height: 30,
                                                                decoration: const BoxDecoration(
                                                                  color: Color(0x00FFFFFF),
                                                                  shape: BoxShape.rectangle,
                                                                ),
                                                                child: const Icon(
                                                                  Icons.image_sharp,
                                                                  color: Colors.black,
                                                                  size: 24,
                                                                ),
                                                              ),
                                                            ),
                                                          ):
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration: const BoxDecoration(
                                                                color: Color(0x00FFFFFF),
                                                                shape: BoxShape.rectangle,
                                                              ),
                                                              child: const Icon(
                                                                Icons.image_not_supported_outlined,
                                                                color: Color(0xFF898585),
                                                                size: 24,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              child:
                                                              // InkWell(
                                                              //   onTap: () {
                                                              //     showDialog(
                                                              //       context: context,
                                                              //       builder: (context) => AlertDialog(
                                                              //         title:  const Text('Are you sure?'),
                                                              //         content:  const Text('Do you want to approve this task'),
                                                              //         actions: <Widget>[
                                                              //           TextButton(
                                                              //             onPressed: () => Navigator.of(context).pop(false),
                                                              //             child:  const Text('No'),
                                                              //           ),
                                                              //           TextButton(
                                                              //             onPressed: () => {
                                                              //               Navigator.of(context).pop(false),
                                                              //               approvtask(snapshot.data["data"][position]["task_id"]),
                                                              //               setState(() {
                                                              //               })},
                                                              //             child:  const Text('Yes'),
                                                              //           ),
                                                              //         ],
                                                              //       ),
                                                              //     );
                                                              //   },
                                                              //   child: Container(
                                                              //
                                                              //
                                                              //     child: Row(children: const [
                                                              //       Icon(
                                                              //         Icons.check,
                                                              //         color: Colors.green,
                                                              //       ),
                                                              //       SizedBox(
                                                              //         width: 5.0,
                                                              //       ),
                                                              //     ]),
                                                              //   ),
                                                              // ),
                                                              checktask(position,snapshot.data["data"][position]["task_id"])
                                                            ),
                                                          ),
                                                          // Expanded(
                                                          //     child:
                                                          //     Container(
                                                          //   child:
                                                          //   InkWell(
                                                          //     onTap: () {
                                                          //       showDialog(
                                                          //           context: context,
                                                          //           builder: (context) => AlertDialog(
                                                          //             title: Text(
                                                          //               "Complete Task",
                                                          //               style: TextStyle(
                                                          //                   color: primaryColor,
                                                          //                   fontWeight: FontWeight.bold),
                                                          //             ),
                                                          //             content: Container(
                                                          //               height: h*0.4,
                                                          //               child: Scaffold(
                                                          //                 resizeToAvoidBottomInset:false,
                                                          //                 body: Form(
                                                          //                   child: Column(
                                                          //                     children: [
                                                          //                       Text("Please fill Remark",
                                                          //                           style: TextStyle(
                                                          //                               color: Colors.black54,
                                                          //                               fontWeight: FontWeight.bold)),
                                                          //                       SizedBox(
                                                          //                         height: h * 0.01,
                                                          //                       ),
                                                          //                       Container(
                                                          //                         //  height: h * 0.07,
                                                          //                         width: w * 0.95,
                                                          //                         child: Card(
                                                          //                           elevation: 3.0,
                                                          //                           child: TextFormField(
                                                          //                             controller: remark,
                                                          //                             maxLines: 8,
                                                          //                             cursorColor: primaryColor,
                                                          //                             decoration: InputDecoration(
                                                          //                                 suffixIcon: Icon(
                                                          //                                   Icons.assignment,
                                                          //                                   color: Colors.red.shade200,
                                                          //                                 ),
                                                          //                                 hintText: "2,3 Done",
                                                          //                                 hintStyle: const TextStyle(
                                                          //                                   color: Colors.black26,
                                                          //                                   fontWeight: FontWeight.bold,
                                                          //                                   fontSize: 14.0,
                                                          //                                 ),
                                                          //                                 filled: true,
                                                          //                                 fillColor: Colors.white,
                                                          //                                 border: const OutlineInputBorder(
                                                          //                                   gapPadding: 9,
                                                          //                                   borderSide: BorderSide.none,
                                                          //                                   borderRadius: BorderRadius.all(
                                                          //                                       Radius.circular(12.0)),
                                                          //                                 ),
                                                          //                                 contentPadding:
                                                          //                                 const EdgeInsets.symmetric(
                                                          //                                     horizontal: 20.0,
                                                          //                                     vertical: 16.0)),
                                                          //                           ),
                                                          //                         ),
                                                          //                       ),
                                                          //                       SizedBox(
                                                          //                         height: h * 0.04,
                                                          //                       ),
                                                          //                       Row(
                                                          //                         mainAxisAlignment:
                                                          //                         MainAxisAlignment.spaceBetween,
                                                          //                         children: [
                                                          //                           TextButton(
                                                          //                             onPressed: () {
                                                          //                               Navigator.pop(context);
                                                          //                             },
                                                          //                             child: const Text(
                                                          //                               "Cancel",
                                                          //                               style: TextStyle(
                                                          //                                 color: Colors.black54,
                                                          //                                 fontWeight: FontWeight.bold,
                                                          //                                 decoration:
                                                          //                                 TextDecoration.underline,
                                                          //                               ),
                                                          //                             ),
                                                          //                           ),
                                                          //                           InkWell(
                                                          //                             onTap: ()  {
                                                          //
                                                          //                               Navigator.pop(context);
                                                          //                               rejtask(snapshot.data["data"][position]["task_id"],remark.value.text);
                                                          //                               setState(() {
                                                          //                               });
                                                          //
                                                          //
                                                          //                             },
                                                          //                             child: Container(
                                                          //                               height: h * 0.04,
                                                          //                               padding: EdgeInsets.symmetric(
                                                          //                                   horizontal: 10.0),
                                                          //                               decoration: BoxDecoration(
                                                          //                                   borderRadius: BorderRadius.all(
                                                          //                                     Radius.circular(6.0),
                                                          //                                   ),
                                                          //                                   color: primaryColor),
                                                          //                               child: Center(
                                                          //                                 child: Text(
                                                          //                                   "Apply",
                                                          //                                   style: TextStyle(
                                                          //                                       color: Colors.white,
                                                          //                                       fontWeight: FontWeight.bold,
                                                          //                                       fontSize: 15.0),
                                                          //                                 ),
                                                          //                               ),
                                                          //                             ),
                                                          //                           ),
                                                          //                         ],
                                                          //                       )
                                                          //                     ],
                                                          //                   ),
                                                          //                 ),
                                                          //               ),
                                                          //             ),
                                                          //           ));
                                                          //     },
                                                          //     child: Container(
                                                          //
                                                          //
                                                          //       child: Row(children: const [
                                                          //         Icon(
                                                          //           Icons.cancel_outlined,
                                                          //           color: Colors.red,
                                                          //         ),
                                                          //
                                                          //       ]),
                                                          //     ),
                                                          //   ),
                                                          // )),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ):Container();
                                      },
                                    ):Center(child: Image.asset("assets/no_data.png")),
                                  ):Center(child: Image.asset("assets/no_data.png"));}
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )

    );
  }
}
class checktask extends StatefulWidget {
   checktask(this.position,this.id ,{Key? key}) : super(key: key);
var position;
var id;
  @override
  State<checktask> createState() => _checktaskState();
}

class _checktaskState extends State<checktask> {
  bool check=false;
  bool
  reject=false;
  @override
  void initState() {
    check= approveid[widget.position]!=""?true:false;
    reject= rejectid[widget.position]!=""?true:false;
    super.initState();
  }
  TextEditingController edtask=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        !reject? Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Checkbox(
              value: check,
              onChanged: (v) {
                if(v==true)
                  {
                    approveid[widget.position]=widget.id.toString();
                  }
                else
                  {
                    approveid[widget.position]="";
                  }
                setState(() {
                  print(approveid);
                  check = v!;
                });
              },
            ),
          ),
        ):Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Checkbox(value: false, onChanged: null),
          ),
        ),
        !check?Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.red,
              value: reject,
              onChanged: (v) {
                if(v==true)
                {
                  showDialog(
                    barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Edit Task",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        content: Container(
                          height: h*0.4,
                          child: Scaffold(
                            resizeToAvoidBottomInset:false,
                            body: Form(
                              child: Column(
                                children: [
                                  const Text("Please Edit Task",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Container(
                                    //  height: h * 0.07,
                                    width: w * 0.95,
                                    child: Card(
                                      elevation: 3.0,
                                      child: TextFormField(
                                        controller: edtask,
                                        maxLines: 8,
                                        cursorColor: primaryColor,
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.assignment,
                                              color: Colors.red.shade200,
                                            ),
                                            hintText: "Task",
                                            hintStyle: const TextStyle(
                                              color: Colors.black26,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: const OutlineInputBorder(
                                              gapPadding: 9,
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 16.0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.04,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            reject=false;
                                          });
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: ()  {
                                          Navigator.pop(context);
                                          rejectid[widget.position]={"id": widget.id, "remark":edtask.value.text};
                                          print(rejectid);
                                          setState(() {
                                          });
                                        },
                                        child: Container(
                                          height: h * 0.04,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(6.0),
                                              ),
                                              color: primaryColor),
                                          child: const Center(
                                            child: Text(
                                              "Apply",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                }
                else
                {
                  rejectid[widget.position]="";
                }
                setState(() {

                  reject = v!;
                });
              },
            ),
          ),
        ):const Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Checkbox(value: false, onChanged: null),
          ),
        )
      ],
    );
  }
}


