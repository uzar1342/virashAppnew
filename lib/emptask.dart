import 'dart:convert';

import 'package:Virash/taskimg.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as ge;
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'empnav.dart';
import 'flutter_flow/flutter_flow_drop_down.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'globals.dart';
String remarks= '';
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
        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
        child: FlutterFlowDropDown(
          initialOption: _value,
          options:  item,
          onChanged: (val) => setState(() => {_value = val!,
            widget.cartItem=_value
          }),
          width: MediaQuery.of(context).size.width * 0.5,
          height: 50,
          textStyle: FlutterFlowTheme.of(context).bodyText1.override(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          fillColor: Colors.white,
          elevation: 2,
          borderColor: FlutterFlowTheme.of(context).primaryBtnText,
          borderWidth: 0,
          borderRadius: 2,
          margin: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
          hidesUnderline: true,
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
  late bool gall=true,cam=true;
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
      gall=false;
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
      cam=false;
    });
  }
  @override
  void initState() {
    _validURL = Uri.parse(widget.cartItem).isAbsolute;
    !_validURL?taskimg=widget.cartItem:"";
    widget.cartItem!="N/A"?gall=false:gall=true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children:  [
                cam?  Expanded(
                  child: GestureDetector(
                    onTap: (){
                      widget.cartItem.trim()==""||widget.cartItem.trim()=="N/A"?
                      addimg():
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
                                            !_validURL?Image.memory(base64Decode(widget.cartItem)):Image.network(widget.cartItem),
                                            SizedBox(
                                              height: h * 0.04,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: ()  {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      _validURL = false;
                                                      gall=true;cam=true;
                                                      widget.cartItem="";
                                                    });
                                                  },
                                                  child: Container(
                                                    height: h * 0.04,
                                                    width: w*0.5,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(6.0),
                                                        ),
                                                        color: primaryColor),
                                                    child: Center(
                                                      child: Text(
                                                        "Cancle",
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
                                ))
                      };
                    },
                    child:  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: gall?Colors.grey:Colors.lightBlue,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                    },
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                gall? Expanded(
                  child: GestureDetector(
                    onTap: (){
                      widget.cartItem.trim()==""||widget.cartItem.trim()=="N/A"?
                      picimg():  {
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
                                            !_validURL?Image.memory(base64Decode(widget.cartItem)):Image.network(widget.cartItem),
                                            SizedBox(
                                              height: h * 0.04,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: ()  {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      _validURL = false;
                                                      gall=true;cam=true;
                                                      widget.cartItem="";
                                                    });
                                                  },
                                                  child: Container(
                                                    height: h * 0.04,
                                                    width: w*0.5,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(6.0),
                                                        ),
                                                        color: primaryColor),
                                                    child: Center(
                                                      child: Text(
                                                        "Cancle",
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
                                ))
                      };;
                    },
                    child:  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Center(
                        child: Icon(
                          Icons.photo_camera_sharp,
                          color: cam?Colors.grey:Colors.lightBlue,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ):
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                    },
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Icon(
                        Icons.photo_camera_sharp,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}







bool isLoading=true;
class EmpTask extends StatefulWidget {
  EmpTask({Key? key,required this.emoid,required this.status,required this.fun, required  this.name,required  this.check,}) : super(key: key);
  Function fun;
  String emoid,check;
  String status;
  String name;

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
  final TextEditingController _searchController = TextEditingController();


  @override
  void didUpdateWidget(EmpTask oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.status != widget.status) {
      setState(() {
        isLoading=true;
        fetchemployetask();
      });
    }
  }



var data;
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
      data= response.data;
      setState(() {
        isLoading=false;
      });
    } else {
      const snackBar = SnackBar(
        content: Text('Unable to fetch employetask'),
        backgroundColor: (Colors.red),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        context.loaderOverlay.hide();
      });
      data= response.data;
      data= response.data;
      setState(() {
        isLoading=false;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    scaleStateController?.dispose();
  }
  @override
  void initState() {
    fetchemployetask();
    super.initState();
    scaleStateController?.scaleState = PhotoViewScaleState.originalSize;
  }
  bool showSearch = true;
  updatetask(taskid) async {
    setState(() {
      isLoading=true;
    });
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
      widget.fun();
      setState(() {
        isLoading=true;
      });
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100.0),
        content:  Text(mapRes["message"]),
        backgroundColor: (primaryColor),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      remark.text= '';
      isLoading=true;
      fetchemployetask();
      setState(() {
        isLoading=true;
      });
    } else {
      final snackBar = SnackBar(
        content:  Text(mapRes["message"]),
        backgroundColor: (Colors.red),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(mapRes["message"]);
      remark.text= '';
    }
  }
  Edittask(taskid,task,emoid,img,prio) async {
    setState(() {
      isLoading=true;
    });
    final url = Uri.parse('http://training.virash.in/editTask');
    var map = Map<String, dynamic>();
    map['admin_id'] = userId;
    map['task_id'] = taskid;
    map['task'] = task;
    map['assigned_to'] = emoid;
    map['task_img'] = img.toString().trim()!="N/A"?img:"".trim();
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
        isLoading=false;
      });
      final snackBar = SnackBar(
        content:  Text(mapRes["message"]),
        backgroundColor: (primaryColor),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      isLoading=true;
      fetchemployetask();

    } else {
      setState(() {
        isLoading=false;
      });
      final snackBar = SnackBar(
        content:  Text(mapRes["message"]),
        backgroundColor: (Colors.red),
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
        body:!isLoading?LoaderOverlay(
          child: Container(
            height: admins.contains(employee_role)?h:h*0.75,
            child: Column(
              children: [
                widget.check=="E"?
                Container(
                  width: w * 0.9,
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
                ):
                showSearch?Container(
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
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(12))),
                        child: TextFormField(
                          autofocus: true,
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
                ),
                Expanded(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: () async {
                      widget.fun();
                      fetchemployetask();
                      isLoading=true;
                      setState(() {
                      });
                      return Future<void>.delayed(const Duration(microseconds: 3));
                    },
                    child: data["data"]!=null&&check>0?
                    GestureDetector(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data["data"].length,
                          itemBuilder: (context, position) {
                            if (data["data"][position]["status"]==widget.status)
                              // ignore: curly_braces_in_flow_control_structures
                              if (data["data"][position]['emp_name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                  _searchController.text.toLowerCase())||data["data"][position]['task']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                  _searchController.text.toLowerCase()))
                              {
                                return

                                  InkWell(
                                    onTap: (){
                                      if(data["data"][position]['status']!="Pending") {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Tasktrail(id: data["data"][position]["task_id"],);
                                          },
                                        );
                                      }
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
                                                                                      data["data"][position]["task"]!=null?data["data"][position]["task"].toString():"",
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
                                                                          text: data["data"][position]["task"]),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
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
                                                                    data["data"][position]["assigned_date"]+"@"+data["data"][position]["assigned_time"],
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
                                                                      color: data["data"][position]["priority"]=="High"?
                                                                      Colors
                                                                          .red:data["data"][position]["priority"]=="Medium"?data["data"][position]["priority"]=="N/A"?Colors
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
                                                                        data["data"][position]["priority"],
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
                                              if (data["data"][position]["status"]=="Completed") Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: data["data"][position]["status"]=="Completed"?
                                                          Color(0xFF91b7ed):data["data"][position]["status"]=="Pending"?Color(0xFFedc791):
                                                          data["data"][position]["status"]=="Rejected"?Color(0xFFed9c91):Color(0xff91edbf),
                                                        ),
                                                        alignment: AlignmentDirectional(0, 0),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Text(
                                                            data["data"][position]["status"],
                                                            textAlign: TextAlign.center,
                                                            style: FlutterFlowTheme.of(context).bodyText1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              else
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: data["data"][position]["status"]=="Completed"?
                                                            Color(0xFF91b7ed):data["data"][position]["status"]=="Pending"?Color(0xFFedc791):
                                                            data["data"][position]["status"]=="Rejected"?Color(0xFFed9c91):Colors.grey,
                                                          ),
                                                          alignment: AlignmentDirectional(0, 0),
                                                          child: Row(
                                                            children: [
                                                              if (widget.check=="E")
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
                                                                                body: SingleChildScrollView(
                                                                                  child: Form(
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
                                                                                                updatetask(data["data"][position]["task_id"].toString());
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
                                                                          "Done",
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
                                                                      taskimg="";
                                                                      print(data["data"][position]["task_id"].toString());
                                                                      edtask.text=data["data"][position]["task"];
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) => AlertDialog(
                                                                            title: Text(
                                                                              "Edit Task",
                                                                              style: TextStyle(
                                                                                  color: primaryColor,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                            content: SingleChildScrollView(
                                                                              child: Container(
                                                                                height: h*0.5,
                                                                                child: Column(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Card(
                                                                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                        color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                        elevation: 2,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                        ),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Card(
                                                                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                                    color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                                    shape: RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                                    ),
                                                                                                    child:  Priorety(cartItem: data["data"][position]["priority"]),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Expanded(flex: 2,child: pickerImage(cartItem: data["data"][position]["task_img"]),),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                    child: Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                                        ),
                                                                                                        child: Padding(
                                                                                                            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                                            child:  Container(
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                                              ),
                                                                                                              child: Padding(
                                                                                                                padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                                                                                                                child: TextFormField(
                                                                                                                  maxLines: 8,
                                                                                                                  controller: edtask,
                                                                                                                  autofocus: true,
                                                                                                                  obscureText: false,
                                                                                                                  decoration: InputDecoration(
                                                                                                                    hintText: 'Enter Task',
                                                                                                                    hintStyle: FlutterFlowTheme.of(context).bodyText2,
                                                                                                                    enabledBorder: OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                        color: FlutterFlowTheme.of(context).lineColor,
                                                                                                                        width: 0,
                                                                                                                      ),
                                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                                    ),
                                                                                                                    focusedBorder: OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                        color: FlutterFlowTheme.of(context).lineColor,
                                                                                                                        width: 0,
                                                                                                                      ),
                                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                                    ),
                                                                                                                    errorBorder: OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                        color: Color(0x00000000),
                                                                                                                        width: 0,
                                                                                                                      ),
                                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                                    ),
                                                                                                                    focusedErrorBorder: OutlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                        color: Color(0x00000000),
                                                                                                                        width: 0,
                                                                                                                      ),
                                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ))))],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      flex: 1,
                                                                                      child: Row(
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

                                                                                                if(edtask.value.text.trim()!="") {
                                                                                                            Navigator.pop(context);
                                                                                                            Edittask(data["data"][position]["task_id"].toString(), edtask.value.text, data["data"][position]["emp_id"].toString(), taskimg, _value);
                                                                                                          }
                                                                                                else
                                                                                                  {
                                                                                                    Flushbar(
                                                                                                      backgroundColor: Colors.red,
                                                                                                      message: "Kindly Provide Task",
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
                                                                                      ),
                                                                                    )


                                                                                  ],
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
                                                                    data["data"][position]["status"],
                                                                    textAlign: TextAlign.center,
                                                                    style: FlutterFlowTheme.of(context).bodyText1,
                                                                  ),
                                                                ),
                                                              ),
                                                              data["data"][position]["status"]!="Pending"?data["data"][position]["rejected_remark"]!="N/A"? Expanded(
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
                                        ),
                                      ),
                                    ),
                                  );
                              }
                              else
                              {
                                return Container();
                              }
                            else {
                              return Container();
                            }
                          }
                      ),
                    ):Center(child: Image.asset("assets/no_data.png")),
                  ),
                ),
              ],
            ),
          ),
        ):Center(child: CircularProgressIndicator(color: Colors.lightBlue))

    );
  }
}


class Tasktrail extends StatefulWidget {
   Tasktrail({Key? key,required this.id}) : super(key: key);
  var id;
  @override
  State<Tasktrail> createState() => _TasktrailState();
}

class _TasktrailState extends State<Tasktrail> {

 Future<dynamic> taskTrail(id) async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "task_id":id
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/taskTrail', data: formData);
    if (response.statusCode == 200) {

      print(response.data);
      return response.data;
    } else {
      final snackBar = const SnackBar(
        content: Text('Unable to fetch taskTrail'),
        backgroundColor: (Colors.red),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return response.data;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 500,
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: // Generated code for this Column Widget...
        FutureBuilder<dynamic>(
          future: taskTrail(widget.id),
          builder: (ctx, snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                        children: [
                          Image.asset("asset/somthing_went_wrong.png")
                          ,const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("somthing went wrong",style: TextStyle(color: Colors.red,fontSize: 20),),
                          )
                        ],
                    ),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                double h = MediaQuery.of(context).size.height;
                double w = MediaQuery.of(context).size.width;
                int len=int.parse(snapshot.data["data"].length.toString());
                return
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data["data"].length,
                    itemBuilder: (context, position) {
                      var date = snapshot.data["data"][position]["date"].split("-");
                      final DateTime now = DateTime.parse("${date[2]}-${date[1]}-${date[0]}");
                      final DateFormat formatter = DateFormat('ddMMM, y');
                      final String formatted = formatter.format(now);
                      return
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color(0x00FFFFFF),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        formatted,
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context).bodyText1.override(
                                          fontFamily: 'Poppins',
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data["data"][position]["time"],
                                        style: FlutterFlowTheme.of(context).bodyText2.override(
                                          fontFamily: 'Poppins',
                                          color: Color(0xE857636C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color(0x00FFFFFF),
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                          snapshot.data["data"][position]["Status"]=="Completed"?
                                          Color(0xFF91b7ed):snapshot.data["data"][position]["Status"]=="Pending"?Color(0xFFedc791):
                                          snapshot.data["data"][position]["Status"]=="Rejected"?Color(0xFFed9c91):
                                          snapshot.data["data"][position]["Status"]=="Approved"?Colors.green:Colors.grey,

                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: len!=(position+1) ?Container(
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          //78len==(position+1)?FlutterFlowTheme.of(context).secondaryBackground:primaryColor,
                                        ),
                                      ):Container(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Color(0x00FFFFFF),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          if(snapshot.data["data"][position]["Status"]=="Rejected"&&snapshot.data["data"][position]["rejected_remark"]!=null)
                                            {
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
                                                              snapshot.data["data"][position]["rejected_remark"]!=null?snapshot.data["data"][position]["rejected_remark"].toString():"",
                                                              maxLines: 8,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            }
                                        },
                                        child: Text(
                                          snapshot.data["data"][position]["Status"],
                                          style: FlutterFlowTheme.of(context).bodyText1.override(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        snapshot.data["data"][position]["responsible"],
                                        style: FlutterFlowTheme.of(context).bodyText1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                    }


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

        ),

      ),
    );
  }
}



