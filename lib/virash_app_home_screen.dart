import 'dart:io';

import 'package:Virash/training/training_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'ViewEmploye.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'bottom_navigation_view/TaskBottomBarView.dart';
import 'empnav.dart';
import 'monthattendence.dart';
import 'virash_app_theme.dart';
import 'globals.dart';
import 'models/tabIcon_data.dart';
import 'my_diary/homescreen.dart';

class VirashAppHomeScreen extends StatefulWidget {
  bool isLoading = false;
  @override
  _VirashAppHomeScreenState createState() => _VirashAppHomeScreenState();
}

class _VirashAppHomeScreenState extends State<VirashAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  bool net = true;
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you really want to exit this app'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  Text('No'),
          ),
          TextButton(
            onPressed: () => exit(0),
            child:  Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
   List<TabIconData> tabIconsList1 = TabIconData.tabIconsList1;

  Widget tabBody = Container(
    color: VirashAppTheme.background,
  );

  @override
  void initState()
  {
    checkinternet();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MyHomeScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: VirashAppTheme.background,
        child: Scaffold(
          resizeToAvoidBottomInset:false,
          backgroundColor: Colors.transparent,
          body: widget.isLoading?Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: primaryColor,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Loading...")
              ],
            ),
          ):FutureBuilder<bool>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return net?Stack(
                  children: <Widget>[
                    tabBody,
                    bottomBar(),
                  ],
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
                    ));
              }
            },
          ),
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: admins.contains(employee_role)?tabIconsList1:tabIconsList,
          addClick: () {
            setState(() {
            widget.isLoading=!widget.isLoading;
          });
            },
          changeIndex: (int index) {
            if (index == 0 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyHomeScreen(animationController: animationController);
                });
              });
             }
    else if (index == 1 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                if(admins.contains(employee_role)) {
                  setState(() {
                  tabBody =
                      EmpTaskNav();

                });
                }
                else{
                  setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);

                });
                }
              });
            }
               else if (index == 2 ) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  !admins.contains(employee_role)?
                  tabBody =  EmpTaskNav():
                  tabBody=viewemp(type: 'T',);
                });
              });
            }else if (index == 3 ) {

                animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  !admins.contains(employee_role)?tabBody = MonthCalendarPage(id: userId, name: employee_name,):
                  tabBody=TrainingScreen(animationController: animationController);
                });
              });

            }
          },
        ),
      ],
    );
  }
}
