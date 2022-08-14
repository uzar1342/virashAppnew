import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("InImage"),
          Expanded(
            child: GestureDetector(onTap:(){
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
                      height: context.height * 0.4,
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



            },child: Image.network(widget.inimage)),
          ),
          Text("outImage"),
        Expanded( child:GestureDetector(
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
                    height: context.height * 0.4,
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



          }, child: Image.network(widget.outimage),
         )
        )],
      ),
    );
  }
}
