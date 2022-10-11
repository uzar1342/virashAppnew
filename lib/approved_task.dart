import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'globals.dart';

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


class checkid  {
  List<check> cart;
  int index;
  checkid({required this.cart, required this.index});
  remove()
  {
    cart.removeAt(index);
  }
}

class _ApprovedTaskState extends State<ApprovedTask> {
  late int check;
  approvtask(taskid) async {
    print(userId);
    setState(() {
      isLoading=false;
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
        isLoading=true;
      });
      return response.data;
    } else {
      setState(() {
        isLoading=true;
      });
      return response.data;
    }
  }
  rejtask(taskid, remark) async {
    print(userId);
    setState(() {
      isLoading=false;
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
        isLoading=true;
      });
      return response.data;
    } else {
      setState(() {
        isLoading=true;
      });
      return response.data;
    }
  }
  bool isLoading=true;
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  TextEditingController remark=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body:isLoading?SafeArea(
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
            child: Column(
              children: [
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
                                                                                    child: Row(children:  [
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
                                                                                                              hintStyle: TextStyle(
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
                                                                                                            padding: EdgeInsets.symmetric(
                                                                                                                horizontal: 10.0),
                                                                                                            decoration: BoxDecoration(
                                                                                                                borderRadius: BorderRadius.all(
                                                                                                                  Radius.circular(6.0),
                                                                                                                ),
                                                                                                                color: primaryColor),
                                                                                                            child: Center(
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
                                                            width: w*0.6,
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
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
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


                                                                child: Row(children: const [
                                                                  Icon(
                                                                    Icons.check,
                                                                    color: Colors.green,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                ]),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(child:Container(
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
                                                                                        hintStyle: TextStyle(
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
                                                                                      padding: EdgeInsets.symmetric(
                                                                                          horizontal: 10.0),
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(6.0),
                                                                                          ),
                                                                                          color: primaryColor),
                                                                                      child: Center(
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


                                                              child: Row(children: const [
                                                                Icon(
                                                                  Icons.cancel_outlined,
                                                                  color: Colors.red,
                                                                ),

                                                              ]),
                                                            ),
                                                          ),
                                                        )),
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
        ):Center(child: CircularProgressIndicator())

    );
  }
}
