import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:homescreen/globals.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:homescreen/shared_prefs_keys.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitness_app_home_screen.dart';
class TakePictureScreen extends StatefulWidget {
   TakePictureScreen({
    super.key, required this.camera,required this.latitude,required this.longitude
  });

  final CameraDescription camera;
  final String latitude;
  final String longitude;
 late SharedPreferences _prefs ;
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;


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



  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Mark Attendence')),
        body: FutureBuilder<void>(
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
        ),
        floatingActionButton: FloatingActionButton(
          // Provide an onPressed callback.
          onPressed: () async {
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;
              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await _controller.takePicture();

              if (!mounted) return;
              // If the picture was taken, display it on a new screen.
              if(attendence)
                {
                 return showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Are you sure?'),
                      content: new Text('Do you want Logout'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Logout_attendence(image),
                          child: new Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Get.offAll(()=>(FitnessAppHomeScreen())),
                          child: new Text('Yes'),
                        ),
                      ],
                    ),
                  );

                }
              else
                {
                  return showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Are you sure?'),
                      content: new Text('Do you want Login'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Login_attendence(image),
                          child: new Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Get.offAll(()=>(FitnessAppHomeScreen())),
                          child: new Text('Yes'),
                        ),
                      ],
                    ),
                  );
                }

            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }
  void Login_attendence(XFile imagePath) async {
    print("Login");
    final url = Uri.parse('http://training.virash.in/emp_attendance');
    var request = MultipartRequest("POST", url);
    request.fields['in_latitude'] = widget.latitude;
    request.fields['in_longitude'] = widget.latitude;
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
    print("logout");
    final url = Uri.parse('http://training.virash.in/emp_attendance');
    var request = MultipartRequest("POST", url);
    request.fields['out_longitude'] = widget.longitude;
    request.fields['out_latitude'] = widget.latitude;
    request.fields['emp_id'] = userId;
    File file = File(imagePath.path);
    var multiPartFile =
    await http.MultipartFile.fromPath("out_image", file.path);
    request.files.add(multiPartFile);
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


}


// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String latitude;
  final String longitude;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        children: [
          Image.file(File(imagePath)),
        ],
      ),
    );
  }


}
