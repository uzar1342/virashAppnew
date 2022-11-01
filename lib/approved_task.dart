import 'dart:convert';
import 'dart:developer';
import 'package:Virash/taskimg.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'emptask.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;





final TextEditingController _searchController = TextEditingController();

class taskbar extends StatefulWidget {
  taskbar(Function() this.refress, this.name ,{Key? key}) : super(key: key);
  var refress;
  var name;

  @override
  State<taskbar> createState() => _taskbarState();
}
class _taskbarState extends State<taskbar> {
  bool showSearch = true;
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xff1f7396);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return  showSearch ?Container(
        padding: const EdgeInsets.only(top: 0.0),
        height: h * 0.09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  // top: 10.0,
                  left: 15.0,
                ),
                //padding: const EdgeInsets.only(left: 5.0),
                height: h * 0.05,
                width: h * 0.05,
                decoration: BoxDecoration(
                  // color: primaryColor,
                    border: Border.all(color: Colors.black26, width: 1.0),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(12.0))),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black87,
                  size: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.name,
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          showSearch = !showSearch;
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: primaryColor,
                      )),
                ],
              ),
            )
          ],
        )):
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: w * 0.7,
          child: Card(
            //margin: EdgeInsets.only(left: 30, right: 30, top: 30),
            elevation: 4,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(12))),
            child: TextFormField(
              autofocus: true,
              controller: _searchController,
              onChanged: (value) {
                widget.refress();
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.orange.shade200,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black38,
                      size: 20.0,
                    ),
                    onPressed: () {
                      widget.refress();
                      _searchController.clear();
                    },
                  ),
                  hintText: "Search",
                  hintStyle: const TextStyle(
                      color: Colors.black26),
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                        Radius.circular(18.0)),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0)),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              setState(() {
                widget.refress();
                _searchController.clear();
                showSearch = !showSearch;
              });
            },
            child: Text("Close",
                style: TextStyle(
                  color: Colors.black54,
                  decoration: TextDecoration.underline,
                ))),
      ],
    );
  }
}


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
  refress()
  {
    setState(() {

    });
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
isloading=true;
    });
    var id=rejid;
    print(id);
  var df=json.encode({"admin_id": userId, "emp_id": widget.emoid, "approved_task": appid, "rejected_task": rejid});
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
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        fetchemployetask();
      });
    } else {
      final snackBar = SnackBar(
        content:  Text(mapRes.values.last.toString()),
        backgroundColor: (Colors.red),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {

        isloading=false;
      });
    }
  }
  @override
  void initState() {
    fetchemployetask();
    super.initState();
  }
  var data;
  fetchemployetask() async {
    data=[];
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
      data= response.data;
      setState(() {
        isloading=false;
      });
    }
    else {
      final snackBar = SnackBar(
        content:  Text("Unable to fetch bank list"),
        backgroundColor: (Colors.red),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      data= response.data;
      setState(() {
        isloading=false;
      });
    }
  }
  bool showSearch = true;
 bool isloading = true;


  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

 
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  TextEditingController remark=TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Color primaryColor = const Color(0xff1f7396);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
              backgroundColor: (Colors.red),

            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }




        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.send),
      ),
        body:LoaderOverlay(
          child:!isloading? SafeArea(
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
                  taskbar(refress,widget.name),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Task',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).subtitle1.override(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Approved Task',
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Rejected Task',
                          style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                    ],
                  ), 
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [



                         
                    data["data"]!=null?Container(
                  child:data["data"].length>0?ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data["data"].length,
                    itemBuilder: (context, position) {
                      if (data["data"][position]['emp_name']
                          .toString()
                          .toLowerCase()
                          .contains(
                          _searchController.text.toLowerCase())||data["data"][position]['task']
                          .toString()
                          .toLowerCase()
                          .contains(
                          _searchController.text.toLowerCase())) {
                        return
                          data["data"][position]["status"]!="Pending"?
                          GestureDetector(
                            onTap: (){

                            },
                            child: Card(
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

                                            showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Tasktrail(id: data["data"][position]["task_id"],);
                                              },
                                            );

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                                                //           text: data["data"][position]["emp_name"].toString()),
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
                                                                                  color: data["data"][position]["priority"]=="high"?
                                                                                  Colors
                                                                                      .red:data["data"][position]["priority"]=="medium"?Colors
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
                                                                                    data["data"][position]["priority"].toString().trim(),
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

                                                                                  data["data"][position]["date_assigned"]!=null?data["data"][position]["date_assigned"].toString():"N/A",
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

                                                                                  data["data"][position]["time_assigned"].toString(),
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
                                                                                data["data"][position]["task"]!=null?data["data"][position]["task"].toString():"",
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
                                                                              data["data"][position]["status"],
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
                                                                                            approvtask(data["data"][position]["task_id"]),
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
                                                                                                  const Text("Please fill Remark",
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
                                                                                                          rejtask(data["data"][position]["task_id"],remark.value.text);
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
                                                    child: Text(
                                                        data["data"][position]["task"]!=null?data["data"][position]["task"].toString():"",
                                                        maxLines: 8,
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black54)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            data["data"][position]["task_img"]!="N/A"?Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (c)=>Taskimg(img:  data["data"][position]["task_img"],)));
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

                                                  checktask(position,data["data"][position]["task_id"])
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ):Container();
                      } else
                        return
                          Container();
                    },
                  ):Center(child: Image.asset("assets/no_data.png")),
        ):Center(child: Image.asset("assets/no_data.png"))
                            
                            
                            
                            
                            ,
                            Container(height: 70,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ):Center(child: CircularProgressIndicator(color: Colors.lightBlue,)),
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
        ):const Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
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
                      builder: (c) => AlertDialog(
                        title: Text(
                          "Remark",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        content:  Container(
                          height: h*0.6,
                          child: Column(
                              children: [
                                const Text("Please Enter Remark",
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
                                          suffixIcon: GestureDetector(
                                            onTap: (){

                                            },
                                            child: Icon(
                                              Icons.assignment,
                                              color: Colors.red.shade200,
                                            ),
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
                                        if(edtask.value.text.trim()!="")
                                        {
                                          Navigator.pop(context);
                                          rejectid[widget.position] = {
                                            "id": widget.id,
                                            "remark": edtask.value.text
                                          };
                                          print(rejectid);
                                          setState(() {});
                                        }
                                        else
                                          {
                                            Flushbar(
                                              backgroundColor: Colors.red,
                                              message: "Kindly Provide Remark",
                                              duration: Duration(seconds: 3),
                                            ).show(context);

                                          }
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


