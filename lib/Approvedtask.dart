import 'package:Virash/taskimg.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'approved_task.dart';
import 'emptask.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'globals.dart';




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


class apptask extends StatefulWidget {
   apptask({Key? key,required this.emoid}) : super(key: key);
var emoid;
  @override
  State<apptask> createState() => _apptaskState();
}

class _apptaskState extends State<apptask> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  bool isloading = true;
  var data;
  fetchemployetask() async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "admin_id":userId,
      "emp_id":widget.emoid,

    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/approvedTasks', data: formData);
    if (response.statusCode == 200) {

      print(response.data);
      data= response.data;
      setState(() {
        isloading=false;
      });
    } else {
      final snackBar = const SnackBar(
        content: Text('Unable to fetch employetask'),
        backgroundColor: (Colors.red),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


      data= response.data;
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
refress()
{
  setState(() {

  });
}
@override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset:false,
        body:LoaderOverlay(
          child: !isloading?Container(
            height: admins.contains(employee_role)?h:h*0.75,
            child: Column(
              children: [
               taskbar(refress, "arbaz"),
                Expanded(
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
                    child:
                    data["data"]!=null?
                    data["data"].length>0?
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: data["data"].length,
                        itemBuilder: (context, position) {
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
                                                        data["data"][position]["status"]=="Rejected"?Color(0xFFed9c91):Color(0xff91edbf),
                                                      ),
                                                      alignment: AlignmentDirectional(0, 0),
                                                      child: Row(
                                                        children: [
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
                          else {
                            return Container();
                          }
                        }
                    ):Center(child: Image.asset("assets/no_data.png")):Center(child: Image.asset("assets/no_data.png"))
                  ),
                ),
              ],
            ),
          ):Center(child: CircularProgressIndicator(color: Colors.lightBlue,)),
        )

    );
  }
}
