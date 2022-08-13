import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        children: [
          Text("InImage"),
          Expanded(child: Image.network(widget.inimage)),
          Text("outImage"),
         Expanded (child:Image.network(widget.outimage)
        )
        ],
      ),
    );
  }
}
