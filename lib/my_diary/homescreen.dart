import 'dart:async';

import 'package:Virash/shared_prefs_keys.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/meals_list_data.dart';
import '../virash_app_theme.dart';
import '../globals.dart';
import '../ui_view/mediterranean_diet_view.dart';
import '../ui_view/title_view.dart';
import 'meals_list_view.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
 int year=DateTime.now().year;
 int day=DateTime.now().day;
 int month=DateTime.now().month;
  String intime="",outtime="",j="",k="";

  viewattendence()
  async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'emp_id':userId,
      "attendance_date":"${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}"
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/dayStatusForEmployee', data: formData);
    if(response.statusCode==200)
    {
      print(response.data);

          intime=response.data["data"][0]["in_time"].toString() ;
          outtime=response.data["data"][0]["out_time"].toString();

return response.data;

    }
    else
    {
      print(response.statusCode);
      return response.data;
    }

  }


  @override
  void initState() {
    print(intime);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    List<MealsListData> mealsListData = MealsListData.tabIconsList;
    return Container(
      color: VirashAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
        Container(
        decoration: BoxDecoration(
            color: VirashAppTheme.white.withOpacity(topBarOpacity),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: VirashAppTheme.grey
                  .withOpacity(0.4 * topBarOpacity),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16 - 8.0 * topBarOpacity,
                bottom: 12 - 8.0 * topBarOpacity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome '+employee_name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: VirashAppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 22 + 6 - 6 * topBarOpacity,
                        letterSpacing: 1.2,
                        color: VirashAppTheme.darkerText,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.calendar_today,
                          color: VirashAppTheme.grey,
                          size: 18,
                        ),
                      ),
                      Text(
                        DateFormat("dd,MMMM").format(DateTime.now()),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: VirashAppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          letterSpacing: -0.2,
                          color: VirashAppTheme.darkerText,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    ),

            Container(
          height: h*0.3,
          width: w*0.95,
          child: FutureBuilder<dynamic>(
                future: viewattendence(), // async work
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return SafeArea(child:Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: VirashAppTheme.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topRight: Radius.circular(68.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: VirashAppTheme.grey.withOpacity(0.2),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 4),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 48,
                                                      width: 2,
                                                      decoration: BoxDecoration(
                                                        color: HexColor('#87A0E5')
                                                            .withOpacity(0.5),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 4, bottom: 2),
                                                            child: Text(
                                                              'in-time',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                VirashAppTheme.fontName,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16,
                                                                letterSpacing: -0.1,
                                                                color: VirashAppTheme.grey
                                                                    .withOpacity(0.5),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.end,
                                                            children: <Widget>[
                                                              SizedBox(
                                                                width: 28,
                                                                height: 28,
                                                                child: Icon(Icons.access_time_filled_outlined,color: Colors.blue,),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 4, bottom: 3),
                                                                child: Text(
                                                                  "N/A",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    VirashAppTheme
                                                                        .fontName,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                    fontSize: 16,
                                                                    color: VirashAppTheme
                                                                        .darkerText,
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 48,
                                                      width: 2,
                                                      decoration: BoxDecoration(
                                                        color: HexColor('#F56E98')
                                                            .withOpacity(0.5),
                                                        borderRadius: const BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 4, bottom: 2),
                                                            child: Text(
                                                              'out-time',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                VirashAppTheme.fontName,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16,
                                                                letterSpacing: -0.1,
                                                                color: VirashAppTheme.grey
                                                                    .withOpacity(0.5),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.end,
                                                            children: const <Widget>[
                                                              SizedBox(
                                                                width: 28,
                                                                height: 28,
                                                                child: Icon(Icons.access_time_filled_outlined
                                                                  ,color: Colors.pink,),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                EdgeInsets.only(
                                                                    left: 4, bottom: 3),
                                                                child: Text(
                                                                  "N/A",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    VirashAppTheme
                                                                        .fontName,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                    fontSize: 16,
                                                                    color: VirashAppTheme
                                                                        .darkerText,
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(right: 16),
                                        //   child: Center(
                                        //     child: Stack(
                                        //       clipBehavior: Clip.none,
                                        //       children: <Widget>[
                                        //         Padding(
                                        //           padding: const EdgeInsets.all(8.0),
                                        //           child: Container(
                                        //             width: 100,
                                        //             height: 100,
                                        //             decoration: BoxDecoration(
                                        //               color: FitnessAppTheme.white,
                                        //               borderRadius: BorderRadius.all(
                                        //                 Radius.circular(100.0),
                                        //               ),
                                        //               border: new Border.all(
                                        //                   width: 4,
                                        //                   color: FitnessAppTheme
                                        //                       .nearlyDarkBlue
                                        //                       .withOpacity(0.2)),
                                        //             ),
                                        //             child: Column(
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment.center,
                                        //               crossAxisAlignment:
                                        //                   CrossAxisAlignment.center,
                                        //               children: <Widget>[
                                        //                 Text(
                                        //                   '${(1503 * animation!.value).toInt()}',
                                        //                   textAlign: TextAlign.center,
                                        //                   style: TextStyle(
                                        //                     fontFamily:
                                        //                         FitnessAppTheme.fontName,
                                        //                     fontWeight: FontWeight.normal,
                                        //                     fontSize: 24,
                                        //                     letterSpacing: 0.0,
                                        //                     color: FitnessAppTheme
                                        //                         .nearlyDarkBlue,
                                        //                   ),
                                        //                 ),
                                        //                 Text(
                                        //                   'Kcal left',
                                        //                   textAlign: TextAlign.center,
                                        //                   style: TextStyle(
                                        //                     fontFamily:
                                        //                         FitnessAppTheme.fontName,
                                        //                     fontWeight: FontWeight.bold,
                                        //                     fontSize: 12,
                                        //                     letterSpacing: 0.0,
                                        //                     color: FitnessAppTheme.grey
                                        //                         .withOpacity(0.5),
                                        //                   ),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         Padding(
                                        //           padding: const EdgeInsets.all(4.0),
                                        //           child: CustomPaint(
                                        //             painter: CurvePainter(
                                        //                 colors: [
                                        //                   FitnessAppTheme.nearlyDarkBlue,
                                        //                   HexColor("#8A98E8"),
                                        //                   HexColor("#8A98E8")
                                        //                 ],
                                        //                 angle: 140 +
                                        //                     (360 - 140) *
                                        //                         (1.0 - animation!.value)),
                                        //             child: SizedBox(
                                        //               width: 108,
                                        //               height: 108,
                                        //             ),
                                        //           ),
                                        //         )
                                        //       ],
                                        //     ),
                                        //   ),
                                        // )
                                        AnalogClock(
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 2.0, color: Colors.black),
                                              color: Colors.transparent,
                                              shape: BoxShape.circle),
                                          width: 100.0,
                                          height: 100,
                                          isLive: true,
                                          hourHandColor: Colors.black,
                                          minuteHandColor: Colors.black,
                                          showSecondHand: true,
                                          numberColor: Colors.black87,
                                          showNumbers: true,
                                          showAllNumbers: true,
                                          textScaleFactor: 1.4,
                                          showTicks: true,
                                          showDigitalClock: true,
                                          datetime: DateTime.now(),
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            )

                        ));
                      } else {
                        Color primaryColor = const Color(0xff1f7396);
                        print("3"+snapshot.data.toString());
                        return   snapshot.data["success"].toString().trim()=="1"?
                        Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: VirashAppTheme.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topRight: Radius.circular(68.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: VirashAppTheme.grey.withOpacity(0.2),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 4),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 48,
                                                      width: 2,
                                                      decoration: BoxDecoration(
                                                        color: HexColor('#87A0E5')
                                                            .withOpacity(0.5),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 4, bottom: 2),
                                                            child: Text(
                                                              'in-time',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                VirashAppTheme.fontName,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16,
                                                                letterSpacing: -0.1,
                                                                color: VirashAppTheme.grey
                                                                    .withOpacity(0.5),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.end,
                                                            children: <Widget>[
                                                              SizedBox(
                                                                width: 28,
                                                                height: 28,
                                                                child: Icon(Icons.access_time_filled_outlined,color: Colors.blue,),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 4, bottom: 3),
                                                                child: Text(
                                                                  intime,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    VirashAppTheme
                                                                        .fontName,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                    fontSize: 16,
                                                                    color: VirashAppTheme
                                                                        .darkerText,
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 48,
                                                      width: 2,
                                                      decoration: BoxDecoration(
                                                        color: HexColor('#F56E98')
                                                            .withOpacity(0.5),
                                                        borderRadius: const BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 4, bottom: 2),
                                                            child: Text(
                                                              'out-time',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                VirashAppTheme.fontName,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16,
                                                                letterSpacing: -0.1,
                                                                color: VirashAppTheme.grey
                                                                    .withOpacity(0.5),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.end,
                                                            children: <Widget>[
                                                              SizedBox(
                                                                width: 28,
                                                                height: 28,
                                                                child: Icon(Icons.access_time_filled_outlined
                                                                  ,color: Colors.pink,),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 4, bottom: 3),
                                                                child: Text(
                                                                  outtime,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    VirashAppTheme
                                                                        .fontName,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                    fontSize: 16,
                                                                    color: VirashAppTheme
                                                                        .darkerText,
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(right: 16),
                                        //   child: Center(
                                        //     child: Stack(
                                        //       clipBehavior: Clip.none,
                                        //       children: <Widget>[
                                        //         Padding(
                                        //           padding: const EdgeInsets.all(8.0),
                                        //           child: Container(
                                        //             width: 100,
                                        //             height: 100,
                                        //             decoration: BoxDecoration(
                                        //               color: FitnessAppTheme.white,
                                        //               borderRadius: BorderRadius.all(
                                        //                 Radius.circular(100.0),
                                        //               ),
                                        //               border: new Border.all(
                                        //                   width: 4,
                                        //                   color: FitnessAppTheme
                                        //                       .nearlyDarkBlue
                                        //                       .withOpacity(0.2)),
                                        //             ),
                                        //             child: Column(
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment.center,
                                        //               crossAxisAlignment:
                                        //                   CrossAxisAlignment.center,
                                        //               children: <Widget>[
                                        //                 Text(
                                        //                   '${(1503 * animation!.value).toInt()}',
                                        //                   textAlign: TextAlign.center,
                                        //                   style: TextStyle(
                                        //                     fontFamily:
                                        //                         FitnessAppTheme.fontName,
                                        //                     fontWeight: FontWeight.normal,
                                        //                     fontSize: 24,
                                        //                     letterSpacing: 0.0,
                                        //                     color: FitnessAppTheme
                                        //                         .nearlyDarkBlue,
                                        //                   ),
                                        //                 ),
                                        //                 Text(
                                        //                   'Kcal left',
                                        //                   textAlign: TextAlign.center,
                                        //                   style: TextStyle(
                                        //                     fontFamily:
                                        //                         FitnessAppTheme.fontName,
                                        //                     fontWeight: FontWeight.bold,
                                        //                     fontSize: 12,
                                        //                     letterSpacing: 0.0,
                                        //                     color: FitnessAppTheme.grey
                                        //                         .withOpacity(0.5),
                                        //                   ),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         Padding(
                                        //           padding: const EdgeInsets.all(4.0),
                                        //           child: CustomPaint(
                                        //             painter: CurvePainter(
                                        //                 colors: [
                                        //                   FitnessAppTheme.nearlyDarkBlue,
                                        //                   HexColor("#8A98E8"),
                                        //                   HexColor("#8A98E8")
                                        //                 ],
                                        //                 angle: 140 +
                                        //                     (360 - 140) *
                                        //                         (1.0 - animation!.value)),
                                        //             child: SizedBox(
                                        //               width: 108,
                                        //               height: 108,
                                        //             ),
                                        //           ),
                                        //         )
                                        //       ],
                                        //     ),
                                        //   ),
                                        // )
                                        AnalogClock(
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 2.0, color: Colors.black),
                                              color: Colors.transparent,
                                              shape: BoxShape.circle),
                                          width: 100.0,
                                          height: 100,
                                          isLive: true,
                                          hourHandColor: Colors.black,
                                          minuteHandColor: Colors.black,
                                          showSecondHand: true,
                                          numberColor: Colors.black87,
                                          showNumbers: true,
                                          showAllNumbers: true,
                                          textScaleFactor: 1.4,
                                          showTicks: true,
                                          showDigitalClock: true,
                                          datetime: DateTime.now(),
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            )

                        ):Image.asset("assets/no_data.png");
                      }
                  }
                },
          ),
        ),


           employee_role=="Super Admin"||employee_role=="Admin"? Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Task List",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: VirashAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: VirashAppTheme.lightText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ):Container(),
            employee_role=="Super Admin"||employee_role=="Admin"||employee_role=="Faculty & Admin"?Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                  mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  widget.animationController?.forward();
                  return Row(
                    children: [
                      MealsView(
                        position: 0,
                        mealsListData: mealsListData[0],
                        animation: animation,
                        animationController:  widget.animationController!,
                      ),
                      employee_role!="Faculty"?MealsView(
                        position: 1,
                        mealsListData: mealsListData[1],
                        animation: animation,
                        animationController:  widget.animationController!,
                      ):Container(),
                      employee_role!="Developer"?MealsView(
                        position: 2,
                        mealsListData: mealsListData[2],
                        animation: animation,
                        animationController: widget. animationController!,
                      ):Container(),
                    ],
                  );
                },
              ),
            ):Container(),


          ],
        ),
      ),
    );
  }




  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }


}
