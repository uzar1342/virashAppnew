import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'globals.dart';

class viewimage extends StatefulWidget {
   viewimage({Key? key,required this.inimage,required this.outimage}) : super(key: key);
String inimage,outimage;
  @override
  State<viewimage> createState() => _viewimageState();
}

class _viewimageState extends State<viewimage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
        Container(
          color: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: AlignmentDirectional(0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: Color(0xFFF5F5F5),
                              child: GestureDetector(
                                onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
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
                                                  Image.network(widget.inimage)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));

                                },
                                child: Image.network(
                                  widget.inimage,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                              ,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                              ),
                              child: Text(
                                'In time',
                                textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: primaryColor,
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Color(0xFFF5F5F5),
                                  child: GestureDetector(
                                    onTap: (){

                                      showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
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
                                                                Image.network(widget.outimage)
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ));



                                    },
                                    child: Image.network(
                                      widget.outimage,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )

                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                               decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                              child: Text(
                                'Out time',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).bodyText1.override(
                                  fontFamily: 'Poppins',
                                  color: primaryColor,
                                ),
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
          ),
        )




        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text("InImage"),
        //     Expanded(
        //       child: GestureDetector(onTap:(){
        //         showDialog(
        //             context: context,
        //             builder: (context) => AlertDialog(
        //               title: Text(
        //                 "View Image",
        //                 style: TextStyle(
        //                     color: primaryColor,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //               content: Container(
        //                 height: context.height * 0.4,
        //                 child: SingleChildScrollView(
        //                   child: Form(
        //                     child: Column(
        //                       children: [
        //                        Image.network(widget.inimage)
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ));
        //
        //
        //
        //       },child: Center(child: Image.network(widget.inimage))),
        //     ),
        //     Text("outImage"),
        //   Expanded( child:GestureDetector(
        //     onTap: (){
        //
        //       showDialog(
        //           context: context,
        //           builder: (context) => AlertDialog(
        //             title: Text(
        //               "View Image",
        //               style: TextStyle(
        //                   color: primaryColor,
        //                   fontWeight: FontWeight.bold),
        //             ),
        //             content: Container(
        //               height: context.height * 0.4,
        //               child: SingleChildScrollView(
        //                 child: Form(
        //                   child: Column(
        //                     children: [
        //                       Image.network(widget.outimage)
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ));
        //
        //
        //
        //     }, child: Center(child: Image.network(widget.outimage)),
        //    )
        //   )],
        // ),
      ),
    );
  }
}
