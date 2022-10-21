import 'package:Virash/taskimg.dart';
import 'package:Virash/tasknav.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'monthattendence.dart';
import 'virash_app_home_screen.dart';
import 'globals.dart';
final TextEditingController _searchController = TextEditingController();
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
var data;
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
      data= response.data;
      setState(() {
        isLoading = false;
      });
    } else {
      data= response.data;
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
   _searchController.clear();
   subscription.cancel;
   super.dispose();
 }
 refress()
 {
   setState(() {

   });
}
  @override
  Widget build(BuildContext context) {
   var h=MediaQuery.of(context).size.height;
   var w=MediaQuery.of(context).size.width;
    return Scaffold(
      body:net?SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              taskbar(refress),
            !isLoading?data["success"].toString().trim()=="1"?
          Container(
            height: h*0.75,
            child: ListView.builder(
              itemCount: data["data"].length,
              physics: ScrollPhysics(),
              itemBuilder: (context, position) {
                if (data["data"][position]['emp_name']
                    .toString()
                    .toLowerCase()
                    .contains(
                    _searchController.text.toLowerCase())) {
                  return

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap:()=>{},
                        child: Card(
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          elevation: 5,
                          child: ListTile(
                            leading:
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
                            title: Text(data["data"][position]["emp_name"]),
                            trailing:data["data"][position]["emp_id"].toString().trim()!=userId? PopupMenuButton<int>(
                              icon: Container(child:Icon(Icons.more_vert)),
                              itemBuilder: (context) => [
                                // PopupMenuItem 1
                                PopupMenuItem(
                                  value: 1,
                                  // row with 2 children
                                  child: Row(
                                    children: const [
                                      Icon(Icons.task),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Task")
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
                                      TaskNav(id: data["data"][position]["emp_id"].toString(), name: data["data"][position]["emp_name"].toString(),)));
                                  // if value 2 show dialog
                                } else if (value == 2) {
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=>
                                      MonthCalendarPage(name: data["data"][position]["emp_name"].toString(), id: data["data"][position]["emp_id"].toString(),))
                                  );
                                }
                              },
                            ):PopupMenuButton<int>(
                              icon: Container(child:Icon(Icons.more_vert)),
                              itemBuilder: (context) => [
                                // PopupMenuItem 1
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
                                      TaskNav(id: data["data"][position]["emp_id"].toString(), name: data["data"][position]["emp_name"].toString(),)));
                                  // if value 2 show dialog
                                } else if (value == 2) {
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=>
                                      MonthCalendarPage(name: data["data"][position]["emp_name"].toString(), id: data["data"][position]["emp_id"].toString(),))
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                }
                else
                  return Container();
              },
            ),
          ):Image.asset("assets/no_data.png"):Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
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


class taskbar extends StatefulWidget {
  taskbar(Function() this.refress, {Key? key}) : super(key: key);
  var refress;
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Employe List",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
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

