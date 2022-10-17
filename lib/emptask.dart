import 'dart:convert';

import 'package:Virash/taskimg.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'globals.dart';
String remarks= '';
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
   PhotoViewScaleStateController? scaleStateController;
  TextEditingController remark=new TextEditingController();
  TextEditingController edtask=new TextEditingController();
  late int check;

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
      print(check);print(widget.status);

      print(response.data);
      return response.data;
    } else {
      final snackBar = SnackBar(
        content: const Text('Unable to fetch employetask'),
        backgroundColor: (primaryColor),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        context.loaderOverlay.hide();
      });
      return response.data;
    }
  }
  taskTrail(id) async {
    check=0;
    print(widget.emoid);
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "task_id":id
    });
    print(formData.fields);
    var response = await dio.post('http://http://training.virash.in/taskTrail', data: formData);
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
      print(check);print(widget.status);

      print(response.data);
      return response.data;
    } else {
      final snackBar = SnackBar(
        content: const Text('Unable to fetch taskTrail'),
        backgroundColor: (primaryColor),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        context.loaderOverlay.hide();
      });
      return response.data;
    }
  }






@override
  void dispose() {

    super.dispose();
    scaleStateController?.dispose();
  }
@override
  void initState() {
    super.initState();
    scaleStateController?.scaleState = PhotoViewScaleState.originalSize;
  }

  updatetask(taskid) async {
    print(remark.value.text);
    final url = Uri.parse('http://training.virash.in/markTaskCompleted');
    var map = Map<String, dynamic>();
    map['emp_id'] = widget.emoid;
    map['completed_task'] = taskid;
    map['remark'] = remark.value.text;
    print(map);
    http.Response response = await http.post(
      url,
      body: map,
    );
    Map mapRes = json.decode(response.body);
    print(mapRes["success"]);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {

      });
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100.0),
        content:  Text(mapRes["message"]),
        backgroundColor: (primaryColor),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      remark.text= '';
    } else {
      final snackBar = SnackBar(
        content:  Text(mapRes["message"]),
        backgroundColor: (primaryColor),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(mapRes["message"]);
      remark.text= '';
    }
  }
  Edittask(taskid,task,emoid,img,prio) async {
    final url = Uri.parse('http://training.virash.in/editTask');
    var map = Map<String, dynamic>();
    map['admin_id'] = userId;
    map['task_id'] = taskid;
    map['task'] = task;
    map['assigned_to'] = emoid;
    map['task_img'] = img!="N/A"?img:"";
    map['priority'] = prio;
    print(map);
    http.Response response = await http.post(
      url,
      body: map,
    );
    Map mapRes = json.decode(response.body);
    print(mapRes["success"]);
    print(response);
    if (response.statusCode == 200) {
      setState(() {

      });
      final snackBar = SnackBar(
        content:  Text(mapRes["message"]),
        backgroundColor: (primaryColor),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content:  Text(mapRes["message"]),
        backgroundColor: (primaryColor),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(mapRes["message"]);
    }
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset:false,
        body:LoaderOverlay(
          child: Container(
            height: admins.contains(employee_role)?h:h*0.75,
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.white,
              backgroundColor: Colors.blue,
              strokeWidth: 4.0,
              onRefresh: () async {
              setState(() {
                });
                return Future<void>.delayed(const Duration(microseconds: 3));
              },
              child: FutureBuilder<dynamic>(
                future: fetchemployetask(), // async work
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
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
                        return
                          snapshot.data["data"]!=null&&check>0?
                          ListView.builder(
                            shrinkWrap: true,
                          itemCount: snapshot.data["data"].length,
                          itemBuilder: (context, position) {
                            if (snapshot.data["data"][position]["status"]==widget.status) {
                              return
                                InkWell(
                                  onTap: (){
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            color: FlutterFlowTheme.of(context).primaryBackground,
                                            child: // Generated code for this Column Widget...


                                            FutureBuilder(
                                              builder: (ctx, snapshot) {
                                                // Checking if future is resolved or not
                                                if (snapshot.connectionState == ConnectionState.done) {
                                                  // If we got an error
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Text(
                                                        '${snapshot.error} occurred',
                                                        style: TextStyle(fontSize: 18),
                                                      ),
                                                    );

                                                    // if we got our data
                                                  } else if (snapshot.hasData) {
                                                    // Extracting data from snapshot object
                                                    final data = snapshot.data as String;
                                                    return Center(
                                                      child: Text(
                                                        '$data',
                                                        style: TextStyle(fontSize: 18),
                                                      ),
                                                    );
                                                  }
                                                }

                                                // Displaying LoadingSpinner to indicate waiting state
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              },

                                              // Future that needs to be resolved
                                              // inorder to display something on the Canvas
                                              future: taskTrail(snapshot.data["data"][position]["emp_id"]),
                                            ),
                                            
                                            
                                            
                                            
                                            
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey.withOpacity(0.1),
                                          spreadRadius: 3,
                                          blurRadius:2,
                                          offset: Offset(0, 7), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      elevation: 3,
                                      surfaceTintColor: Colors.red,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      )),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Padding(
                                                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                                              child:
                                                              GestureDetector(
                                                                onTap: (){
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (context) => AlertDialog(
                                                                        content:
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
                                                                      ));
                                                                },
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  strutStyle: StrutStyle(fontSize: 17.0),
                                                                  text: TextSpan(
                                                                      style:  FlutterFlowTheme.of(context).bodyText1,
                                                                      text: snapshot.data["data"][position]["task"]),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
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
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Padding(
                                                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                                              child: Text(
                                                                snapshot.data["data"][position]["assigned_date"]+"@"+snapshot.data["data"][position]["assigned_time"],
                                                                style: FlutterFlowTheme.of(context).bodyText2.override(
                                                                  fontFamily: 'Poppins',
                                                                  color: Color(0xFF888C91),
                                                                  fontWeight: FontWeight.normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                                                              child: Container(
                                                                width: 30,
                                                                height: 30,
                                                                decoration:  BoxDecoration(
                                                                  color: snapshot.data["data"][position]["priority"]=="High"?
                                                                  Colors
                                                                      .red:snapshot.data["data"][position]["priority"]=="Medium"?snapshot.data["data"][position]["priority"]=="N/A"?Colors
                                                                      .grey:Colors
                                                                      .blue:Colors
                                                                      .green,
                                                                  borderRadius: const BorderRadius.only(
                                                                    bottomLeft: Radius.circular(0),
                                                                    bottomRight: Radius.circular(10),
                                                                    topLeft: Radius.circular(10),
                                                                    topRight: Radius.circular(0),
                                                                  ),
                                                                ),
                                                                child: Align(
                                                                  alignment: AlignmentDirectional(0, 0),
                                                                  child: Text(
                                                                    snapshot.data["data"][position]["priority"],
                                                                    textAlign: TextAlign.center,
                                                                    style: FlutterFlowTheme.of(context)
                                                                        .subtitle1
                                                                        .override(
                                                                      fontFamily: 'Poppins',
                                                                      color: FlutterFlowTheme.of(context)
                                                                          .primaryBtnText,
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (snapshot.data["data"][position]["status"]=="Completed") Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: snapshot.data["data"][position]["status"]=="Completed"?
                                                      Color(0xFF91b7ed):snapshot.data["data"][position]["status"]=="Pending"?Color(0xFFedc791):
                                                      snapshot.data["data"][position]["status"]=="Rejected"?Color(0xFFed9c91):Color(0xff91edbf),
                                                    ),
                                                    alignment: AlignmentDirectional(0, 0),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Text(
                                                        snapshot.data["data"][position]["status"],
                                                        textAlign: TextAlign.center,
                                                        style: FlutterFlowTheme.of(context).bodyText1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ) else Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: snapshot.data["data"][position]["status"]=="Completed"?
                                                      Color(0xFF91b7ed):snapshot.data["data"][position]["status"]=="Pending"?Color(0xFFedc791):
                                                      snapshot.data["data"][position]["status"]=="Rejected"?Color(0xFFed9c91):Colors.grey,
                                                    ),
                                                    alignment: AlignmentDirectional(0, 0),
                                                    child: Row(
                                                      children: [
                                                        if (!admins.contains(employee_role))
                                                          Expanded(
                                                             flex: 1,
                                                             child: GestureDetector(
                                                               onTap: ()
                                                               {
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
                                                                                         updatetask(snapshot.data["data"][position]["task_id"].toString());
                                                                                         setState(() {
                                                                                         });
                                                                                       },
                                                                                       child: Container(
                                                                                         height: h * 0.04,
                                                                                         padding: const EdgeInsets.symmetric(
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
                                                                 width: 30,
                                                                 height: 30,
                                                                 decoration:  BoxDecoration(
                                                                   color: primaryColor,
                                                                   borderRadius: const BorderRadius.only(
                                                                     bottomLeft: Radius.circular(10),
                                                                     bottomRight: Radius.circular(0),
                                                                     topLeft: Radius.circular(0),
                                                                     topRight: Radius.circular(10),
                                                                   ),
                                                                 ),
                                                                 child: Align(
                                                                   alignment: AlignmentDirectional(0, 0),
                                                                   child: Text(
                                                                     "Check",
                                                                     textAlign: TextAlign.center,
                                                                     style: FlutterFlowTheme.of(context)
                                                                         .subtitle1
                                                                         .override(
                                                                       fontFamily: 'Poppins',
                                                                       color: FlutterFlowTheme.of(context)
                                                                           .primaryBtnText,
                                                                       fontSize: 12,
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                             ),
                                                           )
                                                        else
                                                          Expanded(
                                                            flex: 1,
                                                            child: GestureDetector(
                                                              onTap: ()
                                                              {
                                                                print(snapshot.data["data"][position]["task_id"].toString());
                                                                edtask.text=snapshot.data["data"][position]["task"];
                                                                showDialog(
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
                                                                                Text("Please Edit Task",
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
                                                                                        Edittask(snapshot.data["data"][position]["task_id"].toString(),edtask.value.text,snapshot.data["data"][position]["emp_id"].toString(),snapshot.data["data"][position]["task_img"].toString(),snapshot.data["data"][position]["priority"].toString());setState(() {
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
                                                                width: 30,
                                                                height: 30,
                                                                decoration:  BoxDecoration(
                                                                  color: primaryColor,
                                                                  borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(10),
                                                                    bottomRight: Radius.circular(0),
                                                                    topLeft: Radius.circular(0),
                                                                    topRight: Radius.circular(10),
                                                                  ),
                                                                ),
                                                                child: Align(
                                                                  alignment: AlignmentDirectional(0, 0),
                                                                  child: Text(
                                                                    "Edit",
                                                                    textAlign: TextAlign.center,
                                                                    style: FlutterFlowTheme.of(context)
                                                                        .subtitle1
                                                                        .override(
                                                                      fontFamily: 'Poppins',
                                                                      color: FlutterFlowTheme.of(context)
                                                                          .primaryBtnText,
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text(
                                                              snapshot.data["data"][position]["status"],
                                                              textAlign: TextAlign.center,
                                                              style: FlutterFlowTheme.of(context).bodyText1,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ),
                                );
                            } else {
                              return Container();
                            }
                          }
                        ):Center(child: Image.asset("assets/no_data.png"));}
                  }
                },
              ),
            ),
          ),
        ),


    );
  }
}



