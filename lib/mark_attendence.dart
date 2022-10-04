import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart'as mi;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'virash_app_home_screen.dart';
import 'globals.dart';
class TakePictureScreen extends StatefulWidget {
   TakePictureScreen({
     required this.camera,required this.latitude,required this.longitude,required this.title,required this.position
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
  bool net = true;
  bool loader =true;
  late String Address;
  XFile? image=null;
  late Image camerraImage;
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an Attendence'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Get.offAll(()=>(VirashAppHomeScreen())),
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
    print(widget.title);
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

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: net?Container(
          child: loader?SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      height: h * 0.09,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _onWillPop();
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
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          IconButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const AttendancePage()));
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.chartArea,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ],
                      )),
                ),
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
                SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Align(
                       alignment: Alignment.topCenter,
                       child: ElevatedButton(
                           style: ElevatedButton.styleFrom(
                             fixedSize: Size(w*0.8, h*0.078),
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

                               image = await _controller.takePicture();

                               if (!mounted) return;
                               // If the picture was taken, display it on a new screen.

                             setState(() {
                               widget.camraloader=false;
                             });

                               if(attendence.trim()=="True")
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
                                                 Navigator.of(context).pop(false),

                                                   Logout_attendence(image!),
                                                 }
                                               else
                                                 {
                                                 Navigator.of(context).pop(false),
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
                                 return
                                   showDialog(
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
                               Navigator.of(context).pop(false),
                               if(net)
                               {
                               setState(() {
                               loader=false;
                               }),
                                 //Login_attendence(image!),
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
                           , child: Text(widget.title,style: const TextStyle(fontSize: 25),))),
                 )

              ],
            ),
          ):Center(child: CircularProgressIndicator()),
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
            )),

      ),
    );
  }
  void Login_attendence(XFile imagePath) async {
    final url = Uri.parse('http://training.virash.in/emp_attendance');
    var request = MultipartRequest("POST", url);
    request.fields['in_latitude'] = widget.latitude;
    request.fields['in_longitude'] = widget.longitude;
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
        attendence="True";
        Get.offAll(() => VirashAppHomeScreen()) ;
      }
      else
      {
        setState(() {
          loader=true;
        });
        Fluttertoast.showToast(msg:value.toString(),toastLength: Toast.LENGTH_LONG);
      }
    }
    );

  }
  void Logout_attendence(XFile imagePath) async {
    TextEditingController remark=new TextEditingController();
    var h=context.height;
    var w=context.width;
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
                            Navigator.pop(context);
                            setState(() {
                              loader=false;
                            });
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
                                  attendence="False";
                                  Get.offAll(() => VirashAppHomeScreen());
                                }
                                else
                                {
                                  setState(() {
                                    loader=true;
                                  });
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



