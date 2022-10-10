import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';

import 'configs/globals.dart';

class Taskimg extends StatefulWidget {
  String img;
   Taskimg({Key? key,required this.img}) : super(key: key);

  @override
  State<Taskimg> createState() => _TaskimgState();
}

class _TaskimgState extends State<Taskimg> {
  PhotoViewScaleStateController? scaleStateController;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : SafeArea(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 0.0),
                height: MediaQuery.of(context).size.height * 0.09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              // top: 10.0,
                              left: 15.0,
                            ),
                            //padding: const EdgeInsets.only(left: 5.0),
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.height * 0.05,
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
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Text(
                        "Task Image",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                    ),
                  ],
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              height: employee_role=="Admin"||employee_role=="Super Admin"||employee_role=="Faculty & Admin"?MediaQuery.of(context).size.height*0.8:MediaQuery.of(context).size.height*0.87,
              child: PhotoView(
              imageProvider: NetworkImage(widget.img),
              scaleStateController: scaleStateController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


