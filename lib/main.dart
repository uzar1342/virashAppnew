import 'dart:async';
import 'package:Virash/shared_prefs_keys.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'virash_app_home_screen.dart';
import 'globals.dart';
import 'login.dart';



const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,

    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification')
);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp( MyApp());
}


class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  gettoken()
  async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
  }

  @override
  void initState() {


    gettoken();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                importance: Importance.max,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}




class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool isUserLoggedIn = false;
  bool net = false;
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
          getUserLogginStatus();
          timer();
        });
      }
    });
  }
  getUserLogginStatus() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = _prefs.getBool(isUserLoggedInKey) ?? false;
      userId = _prefs.getString(userIdKey) ?? '';
      employee_role=_prefs.getString(Userrole) ?? "";
      employee_name=_prefs.getString(Username) ?? "";
      print("IS USER LOGGED IN: $isUserLoggedIn");
      print(" USER ID: $userId");
      print(" Attendence: $attendence");
      print(" role: $employee_role");
    });
  }
  @override
  void initState() {
    item.clear();
    ADDtaskpriorety();
    checkinternet();
    super.initState();
  }
  @override
  void dispose() {
    subscription.cancel;
    super.dispose();
  }
  ADDtaskpriorety() async {

    Dio dio=Dio();
    var response = await dio.post('http://training.virash.in/showPriority');
    print(response.data.length);
    if (response.statusCode == 200) {
      if(response.data["data"]!=null)
      {
        int len=int.parse(response.data["data"].length.toString());
        for(int i=0;i<len;i++)
        {
          item.add(response.data["data"][i].toString()) ;
        }
      }


    }
    else {
      const snackBar = SnackBar(
        content: Text('Fail to load Priority'),
        backgroundColor: (Colors.red),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:net?Image.asset("assets/logo-withoutBG.png"):SafeArea(
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

  acess()
  async {
    try{
      Dio dio = Dio();
      var formData = FormData.fromMap({
        'emp_id': userId,
      });
      final url = Uri.parse('http://training.virash.in/check_access');
      var response = await dio.post(url.toString(), data: formData);
      if (response.statusCode == 200) {
        String jsonsDataString = response.data.toString();
        List as = jsonsDataString.split(",");
        String sucess = response.data["success"];
        print(sucess);
        if (sucess.trim() == "1") {
          attendence = response.data["attendance_flag"].toString().trim();
          print(attendence);
          check();
        } else {
          final snackBar = SnackBar(
            content: const Text('Acess Dineid'),
            backgroundColor: (Colors.red),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
    catch(c)
    {
      const snackBar = SnackBar(
        content: Text('Acess Dineid'),
        backgroundColor: (Colors.red),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  check()
  {

    if(isUserLoggedIn)
      {
      Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
            (context) =>
                VirashAppHomeScreen()
                ));
      }
      else
        {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
                      HomePage()));
        }
  }


  Future<void> timer() async {

    Timer(Duration(seconds: 2),
            (){
              if(userId!="")
                {
                  acess();
                }
              else
                {
                  check();
                }

            }

           // TakePictureScreen(camera: firstCamera,)

    );

  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
