import 'package:Virash/page/profile_page.dart';
import 'package:flutter/material.dart';
class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  Animation<double>? topBarAnimation;
  @override

  @override
  Widget build(BuildContext context) {
    return
       Builder(
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ProfilePage(),
        ),
      );

  }
}
