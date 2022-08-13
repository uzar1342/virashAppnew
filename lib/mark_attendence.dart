import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:Virash/shared_prefs_keys.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart'as mi;
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitness_app_home_screen.dart';
import 'globals.dart';
class TakePictureScreen extends StatefulWidget {
   TakePictureScreen({
    super.key, required this.camera,required this.latitude,required this.longitude,required this.title,required this.position
  });

  final CameraDescription camera;
  final Position position;
  final String title;
  final String latitude;
  final String longitude;
  bool camraloader=true;
 late SharedPreferences _prefs ;
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool net = false;
  late String Address;
    XFile? image=null;
  late Image camerraImage;
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an Attendence'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Get.offAll(()=>(FitnessAppHomeScreen())),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
     Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

  }

  @override
  void initState() {
    super.initState();
    GetAddressFromLatLong(widget.position);
    checkinternet();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    Shairfrence();
  }
  Shairfrence()
  async {
    widget._prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  checkinternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      net=true;
    } else {
      net=false;
      Fluttertoast.showToast(msg: "No Internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title:  Text(widget.title.toString())),
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: widget.camraloader?
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ): Image.file(File(image!.path)),
            ),
            SizedBox(height: 20),
             Expanded(
              flex: 1,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:const mi.Size(double.infinity, 80),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              // Ensure that the camera is initialized.
                              await _initializeControllerFuture;
                              // Attempt to take a picture and get the file `image`
                              // where it was saved.
                              image = await _controller.takePicture();

                              if (!mounted) return;
                              // If the picture was taken, display it on a new screen.

                            setState(() {
                              widget.camraloader=false;
                            });

                              if(attendence)
                              {
                                return showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:  const Text('Are you sure?'),
                                    content:  const Text('Do you want Logout'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                        {
                                        setState(() {
                                        widget.camraloader=true;
                                        }),

                                          Navigator.of(context).pop(false)},
                                        child:  const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            {
                                              if(net)
                                                {
                                                  Logout_attendence(image!),
                                                }
                                              else
                                                {
                                                Fluttertoast.showToast(msg: "No Internet")
                                                }
                                            },
                                            child:  const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );

                              }
                              else
                              {
                                return showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Are you sure?'),
                                    content: const Text('Do you want Login'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                        {setState(() {
                                          widget.camraloader=true;
                                        }),
                                          Navigator.of(context).pop(false)},
                                        child:  const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () =>  {
                              if(net)
                              {
                                Login_attendence(image!),
                              }
                              else
                              {
                              Fluttertoast.showToast(msg: "No Internet")
                              }

                              },
                                        child:  const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                            } catch (e) {
                              // If an error occurs, log the error to the console.
                              print(e);
                            }
                          }
                          , child: Text(widget.title,style: const TextStyle(fontSize: 25),)),
                    )))

          ],
        ),

      ),
    );
  }

  void Login_attendence(XFile imagePath) async {
    final url = Uri.parse('http://training.virash.in/emp_attendance');
    var request = MultipartRequest("POST", url);
    request.fields['in_latitude'] = widget.latitude;
    request.fields['in_longitude'] = widget.latitude;
    request.fields['in_location'] = Address;
    request.fields['emp_id'] = userId;
    File file = File(imagePath.path);
    var multiPartFile =
    await http.MultipartFile.fromPath("in_image", file.path);
    request.files.add(multiPartFile);
    print(request.fields);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      if(response.statusCode==200)
      {
        attendence=true;
        widget._prefs.setBool(Userattendence,true);
        Get.offAll(() => FitnessAppHomeScreen()) ;
      }
      else
      {
        Fluttertoast.showToast(msg:value.toString(),toastLength: Toast.LENGTH_LONG);
      }
    }
    );

  }
  void Logout_attendence(XFile imagePath) async {
    TextEditingController remark=new TextEditingController();
    var h=context.height;
    var w=context.width;
    Navigator.of(context).pop(false);
    print("logout");

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Add Task",
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
                    Text("Please fill today's Task",
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
                          maxLines: 8,
                          controller: remark,
                          onChanged: (text) {
                            setState(() {});
                          },
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.assignment,
                                color: Colors.red.shade200,
                              ),
                              hintText: "Remark",
                              hintStyle: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                gapPadding: 9,
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(12.0)),
                              ),
                              contentPadding:
                              EdgeInsets.symmetric(
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
                          child: Text(
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
                          onTap: () async {
                          if(remark.value.text!="")
                            {
                              final url = Uri.parse('http://training.virash.in/emp_attendance');
                              var request = MultipartRequest("POST", url);
                              request.fields['out_longitude'] = widget.longitude;
                              request.fields['out_latitude'] = widget.latitude;
                              request.fields['out_location'] =Address;
                              request.fields['emp_id'] = userId;
                              File file = File(imagePath.path);
                              var multiPartFile =
                              await http.MultipartFile.fromPath("out_image", file.path);
                              request.files.add(multiPartFile);
                              print(request.fields);
                              request.fields['task'] = remark.value.text;
                              print(request.fields);
                              var response = await request.send();
                              response.stream.transform(utf8.decoder).listen((value) {
                                if(response.statusCode==200)
                                {
                                  attendence=false;
                                  widget._prefs.setBool(Userattendence,false);
                                  Get.offAll(() => FitnessAppHomeScreen()) ;
                                }
                                else
                                {
                                  Fluttertoast.showToast(msg:value.toString(),toastLength: Toast.LENGTH_LONG);
                                }
                              }
                              );
                            }
                          else
                            Fluttertoast.showToast(msg: "fill Task");

                          },
                          child: Container(
                            height: h * 0.04,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                color: primaryColor),
                            child: Center(
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



  }


}



