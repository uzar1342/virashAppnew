import 'dart:convert';
import 'dart:developer';

import 'package:Virash/taskimg.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'flutter_flow/flutter_flow_theme.dart';
import 'globals.dart';



String _value = "Low";
class Priorety extends StatefulWidget {
  String cartItem;

  Priorety({required this.cartItem});
  @override
  _PrioretyState createState() => _PrioretyState();
}

class _PrioretyState extends State<Priorety> {

  @override
  void initState() {
    super.initState();
    _value= widget.cartItem!=""?widget.cartItem:"Low";
  }






  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity - 50,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              filled: true,
              fillColor: Colors.blueGrey,
            ),
            dropdownColor: Colors.blueGrey,
            isExpanded: false,
            items: item

            ,
            onChanged: (value) {
              setState(() {
                _value = value.toString();
                widget.cartItem = _value;
              });
            },
            value: _value,
            hint: const Text(
              "Select Priority",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),


    );
  }
}

String taskimg="";
class pickerImage extends StatefulWidget {
  String cartItem;
  pickerImage({Key? key,required this.cartItem}) : super(key: key);
  @override
  State<pickerImage> createState() => _pickerImageState();
}
class _pickerImageState extends State<pickerImage> {
  late bool selectimg;
  bool _validURL=false;
  final ImagePicker _picker = ImagePicker();
  addimg()
  async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery ,imageQuality: 15);
    final bytes = await Io.File(image!.path.toString()).readAsBytes();
    String img64 = base64Encode(bytes);
    print(img64);
    taskimg=img64;
    widget.cartItem=img64;
    setState(() {
      selectimg=!selectimg;
    });
  }
  picimg()
  async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 15);
    final bytes = await Io.File(image!.path.toString()).readAsBytes();
    String img64 = base64Encode(bytes);
    print(img64);
    taskimg=img64;
    widget.cartItem=img64;
    setState(() {
      selectimg=!selectimg;
    });
  }
  @override
  void initState() {
    _validURL = Uri.parse(widget.cartItem).isAbsolute;
    !_validURL?taskimg=widget.cartItem:"";
    widget.cartItem!="N/A"?selectimg=false:selectimg=true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  selectimg?Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){
              picimg();
            }, child: Text("Image from camera")),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){
              addimg();
            }, child: Text("Image from gallery")),
          ),
        ),
      ],
    ):
    Container(
      decoration: BoxDecoration(
        color: Color(0xb1eee7e7),
        borderRadius: BorderRadius.circular(50),
        shape: BoxShape.rectangle,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Setected',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).title1,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(!_validURL) {
                        var _byteImage = Base64Decoder().convert(
                            taskimg);
                        showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  title: Text(
                                    "View Image",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Container(
                                    child: SingleChildScrollView(
                                      child: Form(
                                        child: Column(
                                          children: [
                                            Image.memory(
                                              _byteImage, height: 200,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                      }
                      else
                      {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  title: Text(
                                    "View Image",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Container(
                                    child: SingleChildScrollView(
                                      child: Form(
                                        child: Column(
                                          children: [
                                            Image.network(
                                              widget.cartItem, height: 200,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                      }
                    },
                    child: Icon(
                      Icons.image,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.cartItem="";
                      _validURL=false;
                      selectimg=true;
                    });
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


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
  var data;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  late int check;
  bool showSearch = true;
  bool isLoading=true;
  fetchemployetask() async {
    check=0;
    print(widget.emoid);
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "emp_id":widget.emoid
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/allEmployeeTodaysTask', data: formData);
    if (response.statusCode == 200) {

      log(response.data["data"].toString());
      print(check);
      print(response.data);
      data=response.data;
      setState(() {
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to fetch bank list");
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    fetchemployetask();
    super.initState();
  }
  TextEditingController edtask=new TextEditingController();
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
    print(response.statusCode);
    if (response.statusCode == 200) {
      isLoading=true;
      fetchemployetask();
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
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return Scaffold(
        body:SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: showSearch?Container(
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
                            "Task List",
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
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12))),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
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
                            setState(() {

                              _searchController.clear();
                            });
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
                      showSearch = !showSearch;
                    });
                  },
                  child: Text("Close",
                      style: TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.underline,
                      ))),
            ],
          ),
              ),
              Expanded(
                flex: 8,
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.white,
                  backgroundColor: Colors.blue,
                  strokeWidth: 4.0,
                  onRefresh: () async {
                    _refreshIndicatorKey.currentState?.show();
                    isLoading=true;
                    fetchemployetask();
                    setState(() {
                    });
                    return Future<void>.delayed(const Duration(milliseconds: 3));
                  },
                  child: SafeArea(
                      child: data==null?Container(
                        width: double.infinity,
                        color: Colors
                            .white,
                        child: Scaffold(body: Center(child: CircularProgressIndicator())),
                      ):
                      data["data"]!=null?Container(
                        child: data["data"].length>0?
                        ListView.builder(
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
                              return Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey
                                          .withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 2,
                                      offset: const Offset(0,
                                          7), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  EdgeInsets.all(4.0),
                                  child:   data["data"][position]
                                  [
                                  "status"] != "Cancelled"?Card(
                                    elevation: 3,
                                    surfaceTintColor: Colors.red,
                                    shape:
                                    const RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.only(
                                          bottomLeft:
                                          Radius.circular(10),
                                          bottomRight:
                                          Radius.circular(10),
                                          topLeft:
                                          Radius.circular(10),
                                          topRight:
                                          Radius.circular(10),
                                        )),
                                    clipBehavior: Clip
                                        .antiAliasWithSaveLayer,
                                    child: Column(
                                      mainAxisSize:
                                      MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize:
                                          MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(8.0),
                                              child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  clipBehavior: Clip
                                                      .antiAlias,
                                                  decoration:
                                                  const BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                  ),
                                                  child: Image
                                                      .network(
                                                    data[
                                                    "data"]
                                                    [
                                                    position]
                                                    [
                                                    "profile_img"],
                                                    loadingBuilder: (BuildContext
                                                    context,
                                                        Widget
                                                        child,
                                                        ImageChunkEvent?
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                        CircularProgressIndicator(
                                                          value: loadingProgress.expectedTotalBytes !=
                                                              null
                                                              ? loadingProgress.cumulativeBytesLoaded /
                                                              loadingProgress.expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  )),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize
                                                    .max,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .max,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child:
                                                        GestureDetector(
                                                          onTap:
                                                              () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (context) => AlertDialog(
                                                                  content: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons.assignment,
                                                                        color: Colors.red.shade200,
                                                                      ),
                                                                      SizedBox(
                                                                        width: w * 0.01,
                                                                      ),
                                                                      Container(
                                                                        width: w * 0.5,
                                                                        child: Text(data["data"][position]["task"] != null ? data["data"][position]["task"].toString() : "", maxLines: 8, style: const TextStyle(color: Colors.black54)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ));
                                                          },
                                                          child:
                                                          RichText(
                                                            maxLines:
                                                            1,
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            strutStyle:
                                                            StrutStyle(fontSize: 17.0),
                                                            text: TextSpan(
                                                                style: FlutterFlowTheme.of(context).bodyText1,
                                                                text: data["data"][position]["task"]),
                                                          ),
                                                        ),
                                                      ),
                                                      data["data"][position]["task_img"] !=
                                                          "N/A"
                                                          ? Expanded(
                                                        flex:
                                                        1,
                                                        child:
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (c) => Taskimg(
                                                                      img: data["data"][position]["task_img"],
                                                                    )));
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
                                                      )
                                                          : Expanded(
                                                        flex:
                                                        1,
                                                        child:
                                                        Container(
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
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .max,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child:
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                              10,
                                                              0,
                                                              0,
                                                              0),
                                                          child:
                                                          Text(
                                                            data["data"][position]["assigned_date"] +
                                                                "@" +
                                                                data["data"][position]["assigned_time"],
                                                            style: FlutterFlowTheme.of(context)
                                                                .bodyText2
                                                                .override(
                                                              fontFamily: 'Poppins',
                                                              color: Color(0xFF888C91),
                                                              fontWeight: FontWeight.normal,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                              10,
                                                              0,
                                                              10,
                                                              10),
                                                          child:
                                                          Container(
                                                            width:
                                                            30,
                                                            height:
                                                            30,
                                                            decoration:
                                                            BoxDecoration(
                                                              color: data["data"][position]["priority"] == "High"
                                                                  ? Colors.red
                                                                  : data["data"][position]["priority"] == "Medium"
                                                                  ? Colors.blue
                                                                  : Colors.green,
                                                              borderRadius:
                                                              const BorderRadius.only(
                                                                bottomLeft: Radius.circular(0),
                                                                bottomRight: Radius.circular(10),
                                                                topLeft: Radius.circular(10),
                                                                topRight: Radius.circular(0),
                                                              ),
                                                            ),
                                                            child:
                                                            Align(
                                                              alignment:
                                                              AlignmentDirectional(0, 0),
                                                              child:
                                                              Text(
                                                                data["data"][position]["priority"],
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).subtitle1.override(
                                                                  fontFamily: 'Poppins',
                                                                  color: FlutterFlowTheme.of(context).primaryBtnText,
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
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              0, 8, 0, 0),
                                          child: Row(
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    color: data["data"][position]
                                                    [
                                                    "status"] ==
                                                        "Completed"
                                                        ? Color(
                                                        0xFF91b7ed)
                                                        : data["data"][position]["status"] ==
                                                        "Pending"
                                                        ? Color(
                                                        0xFFedc791)
                                                        : data["data"][position]["status"] == "Rejected"
                                                        ? Color(0xFFed9c91)
                                                        : Colors.grey,
                                                  ),
                                                  alignment:
                                                  AlignmentDirectional(
                                                      0, 0),
                                                  child: Row(
                                                    children: [
                                                      data["data"][position]["status"] !=
                                                          "Completed"
                                                          ? Expanded(
                                                        flex:
                                                        1,
                                                        child:
                                                        GestureDetector(
                                                          onTap: () {
                                                            taskimg="";
                                                            edtask.text = data["data"][position]["task"];
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
                                                                    height: h*0.6,
                                                                    child: Scaffold(
                                                                      resizeToAvoidBottomInset:false,
                                                                      body: SingleChildScrollView(
                                                                        child: Form(
                                                                          child: Column(
                                                                            children: [
                                                                              Priorety(cartItem: data["data"][position]["priority"]),
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
                                                                              pickerImage(cartItem: data["data"][position]["task_img"]),
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

                                                                                      Edittask(data["data"][position]["task_id"].toString(),edtask.value.text,
                                                                                          data["data"][position]["emp_id"].toString(),
                                                                                          taskimg,
                                                                                          _value);

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
                                                                  ),
                                                                ));
                                                          },
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration: BoxDecoration(
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
                                                                style: FlutterFlowTheme.of(context).subtitle1.override(
                                                                  fontFamily: 'Poppins',
                                                                  color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                          : Container(),
                                                      Expanded(
                                                        flex: 3,
                                                        child:
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(5.0),
                                                          child:
                                                          Text(
                                                            data["data"][position]
                                                            [
                                                            "status"],
                                                            textAlign:
                                                            TextAlign.center,
                                                            style:
                                                            FlutterFlowTheme.of(context).bodyText1,
                                                          ),
                                                        ),
                                                      ),
                                                      data["data"][position]["status"]!="Pending"?
                                                      data["data"][position]["rejected_remark"]!="N/A"&&data["data"][position]["rejected_remark"]!=null? Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: ()
                                                          {
                                                            print(data["data"][position]["task_id"].toString());
                                                            edtask.text=data["data"][position]["task"];
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
                                                                            data["data"][position]["rejected_remark"]!=null?data["data"][position]["rejected_remark"].toString():"",
                                                                            maxLines: 8,
                                                                            style: const TextStyle(
                                                                                color: Colors
                                                                                    .black54)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ));
                                                          },
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:  BoxDecoration(
                                                              color: primaryColor,
                                                              borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius.circular(0),
                                                                bottomRight: Radius.circular(10),
                                                                topLeft: Radius.circular(10),
                                                                topRight: Radius.circular(0),
                                                              ),
                                                            ),
                                                            child: Align(
                                                              alignment: AlignmentDirectional(0, 0),
                                                              child: Text(
                                                                "Remark",
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
                                                      ):Container():Container(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ):
                                  Card(
                                    color: Color(0x83ffffff),
                                    elevation: 3,
                                    surfaceTintColor: Colors.red,
                                    shape:
                                    const RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.only(
                                          bottomLeft:
                                          Radius.circular(10),
                                          bottomRight:
                                          Radius.circular(10),
                                          topLeft:
                                          Radius.circular(10),
                                          topRight:
                                          Radius.circular(10),
                                        )),
                                    clipBehavior: Clip
                                        .antiAliasWithSaveLayer,
                                    child: Column(
                                      mainAxisSize:
                                      MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize:
                                          MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(8.0),
                                              child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  clipBehavior: Clip
                                                      .antiAlias,
                                                  decoration:
                                                  BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                  ),
                                                  child: Image
                                                      .network(
                                                    data[
                                                    "data"]
                                                    [
                                                    position]
                                                    [
                                                    "profile_img"],
                                                    loadingBuilder: (BuildContext
                                                    context,
                                                        Widget
                                                        child,
                                                        ImageChunkEvent?
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                        CircularProgressIndicator(
                                                          value: loadingProgress.expectedTotalBytes !=
                                                              null
                                                              ? loadingProgress.cumulativeBytesLoaded /
                                                              loadingProgress.expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  )),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize
                                                    .max,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .max,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child:
                                                        GestureDetector(
                                                          onTap:
                                                              () {

                                                          },
                                                          child:
                                                          RichText(
                                                            maxLines:
                                                            1,
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            strutStyle:
                                                            StrutStyle(fontSize: 17.0),
                                                            text: TextSpan(
                                                                style: FlutterFlowTheme.of(context).bodyText1,
                                                                text: data["data"][position]["task"]),
                                                          ),
                                                        ),
                                                      ),
                                                      data["data"][position]["task_img"] !=
                                                          "N/A"
                                                          ? Expanded(
                                                        flex:
                                                        1,
                                                        child:
                                                        GestureDetector(
                                                          onTap: () {

                                                          },
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                              color: Color(0x00FFFFFF),
                                                              shape: BoxShape.rectangle,
                                                            ),
                                                            child: Icon(
                                                              Icons.image_sharp,
                                                              color: Colors.black,
                                                              size: 24,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                          : Expanded(
                                                        flex:
                                                        1,
                                                        child:
                                                        Container(
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
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .max,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child:
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                              10,
                                                              0,
                                                              0,
                                                              0),
                                                          child:
                                                          Text(
                                                            data["data"][position]["assigned_date"] +
                                                                "@" +
                                                                data["data"][position]["assigned_time"],
                                                            style: FlutterFlowTheme.of(context)
                                                                .bodyText2
                                                                .override(
                                                              fontFamily: 'Poppins',
                                                              color: Color(0xFF888C91),
                                                              fontWeight: FontWeight.normal,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                        Padding(
                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                              10,
                                                              0,
                                                              10,
                                                              10),
                                                          child:
                                                          Container(
                                                            width:
                                                            30,
                                                            height:
                                                            30,
                                                            decoration:
                                                            BoxDecoration(
                                                              color: data["data"][position]["priority"] == "High"
                                                                  ? Colors.red
                                                                  : data["data"][position]["priority"] == "Medium"
                                                                  ? Colors.blue
                                                                  : Colors.green,
                                                              borderRadius:
                                                              const BorderRadius.only(
                                                                bottomLeft: Radius.circular(0),
                                                                bottomRight: Radius.circular(10),
                                                                topLeft: Radius.circular(10),
                                                                topRight: Radius.circular(0),
                                                              ),
                                                            ),
                                                            child:
                                                            Align(
                                                              alignment:
                                                              AlignmentDirectional(0, 0),
                                                              child:
                                                              Text(
                                                                data["data"][position]["priority"],
                                                                textAlign: TextAlign.center,
                                                                style: FlutterFlowTheme.of(context).subtitle1.override(
                                                                  fontFamily: 'Poppins',
                                                                  color: FlutterFlowTheme.of(context).primaryBtnText,
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
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              0, 8, 0, 0),
                                          child: Row(
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    color: data["data"][position]
                                                    [
                                                    "status"] ==
                                                        "Completed"
                                                        ? Color(
                                                        0xFF91b7ed)
                                                        : data["data"][position]["status"] ==
                                                        "Pending"
                                                        ? Color(
                                                        0xFFedc791)
                                                        : data["data"][position]["status"] == "Rejected"
                                                        ? Color(0xFFed9c91)
                                                        : Colors.grey,
                                                  ),
                                                  alignment:
                                                  AlignmentDirectional(
                                                      0, 0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child:
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(5.0),
                                                          child:
                                                          Text(
                                                            data["data"][position]
                                                            [
                                                            "status"],
                                                            textAlign:
                                                            TextAlign.center,
                                                            style:
                                                            FlutterFlowTheme.of(context).bodyText1,
                                                          ),
                                                        ),
                                                      )
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
                              );
                            }
                            else
                              return  Container();
                          },
                        ):Container(child: Center(child: Image.asset("assets/no_data.png")),),
                      ):Center(child: Image.asset("assets/no_data.png"))


                  ),
                ),
              ),
            ],
          ),
        )

    );
  }
}
