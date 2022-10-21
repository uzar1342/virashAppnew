import 'package:Virash/taskimg.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'emptask.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'globals.dart';

class apptask extends StatefulWidget {
   apptask({Key? key,required this.emoid}) : super(key: key);
var emoid;
  @override
  State<apptask> createState() => _apptaskState();
}

class _apptaskState extends State<apptask> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  final TextEditingController _searchController = TextEditingController();

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

@override
  void initState() {
  fetchemployetask();
    super.initState();
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                    ),
                  ],
                ),
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
                    child:FutureBuilder<dynamic>(
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
                                            "something went wrong",
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
                                snapshot.data["data"]!=null?
                                snapshot.data["data"].length>0?
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data["data"].length,
                                    itemBuilder: (context, position) {
                                        // ignore: curly_braces_in_flow_control_structures
                                        if (snapshot.data["data"][position]['emp_name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(
                                            _searchController.text.toLowerCase())||snapshot.data["data"][position]['task']
                                            .toString()
                                            .toLowerCase()
                                            .contains(
                                            _searchController.text.toLowerCase()))
                                        {
                                          return

                                            InkWell(
                                              onTap: (){
                                                if(snapshot.data["data"][position]['status']!="Pending") {
                                                  showModalBottomSheet<void>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Tasktrail(id: snapshot.data["data"][position]["task_id"],);
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
                                                                      color: snapshot.data["data"][position]["status"]=="Completed"?
                                                                      Color(0xFF91b7ed):snapshot.data["data"][position]["status"]=="Pending"?Color(0xFFedc791):
                                                                      snapshot.data["data"][position]["status"]=="Rejected"?Color(0xFFed9c91):Color(0xff91edbf),
                                                                    ),
                                                                    alignment: AlignmentDirectional(0, 0),
                                                                    child: Row(
                                                                      children: [
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
                                        }
                                      else {
                                        return Container();
                                      }
                                    }
                                ):Center(child: Image.asset("assets/no_data.png")):Center(child: Image.asset("assets/no_data.png"));}
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )

    );
  }
}
