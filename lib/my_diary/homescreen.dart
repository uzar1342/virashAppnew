import 'dart:async';

import 'package:Virash/shared_prefs_keys.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
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
      'year': year.toString(),
      'month': month>=10?month.toString():"0"+month.toString(),
      "day" :   day>=10?day.toString():"0"+day.toString(),
      "role":   employee_role,
      "emp_id":  userId
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/allEmployeesAttendanceDetails', data: formData);
    if(response.statusCode==200)
    {
      print(response.data);
      intime=response.data["data"][0]["in_time"].toString() ;
      outtime=response.data["data"][0]["out_time"].toString();
    }
    else
    {
      print(response.statusCode);
    }

  }


  @override
  void initState() {
    viewattendence();
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

    listViews.add(
      TitleView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(time());

    if(employee_role=="Admin"||employee_role=="Super Admin")
      {
        listViews.add(
          TitleView(
            titleTxt: 'Task list',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController!,
                curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController!,
          ),
        );
        listViews.add(
          MealsListView(
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController!,
                    curve: Interval((1 / count) * 3, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: widget.animationController,
          ),
        );
      }



  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: VirashAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget time(){
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController!,
              curve:
              Interval((1 / 9) * 0, 1.0, curve: Curves.fastOutSlowIn)))!,
          child: Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController!,
                curve:
                Interval((1 / 9) * 0, 1.0, curve: Curves.fastOutSlowIn)))!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: VirashAppTheme.white,
                  borderRadius: BorderRadius.only(
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
                                                  child: Icon(Icons.access_time_filled_outlined),
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
                                                  child: Icon(Icons.access_time_filled_outlined),
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
              ),
            ),
          ),
        );
      },
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

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
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
              ),
            );
          },
        )
      ],
    );
  }
}
