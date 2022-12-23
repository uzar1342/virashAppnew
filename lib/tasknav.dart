import 'package:Virash/training/training_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'Approvedtask.dart';
import 'taskAdd.dart';
import 'approved_task.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'bottom_navigation_view/TaskBottomBarView.dart';
import 'completetask.dart';
import 'emptask.dart';
import 'emptask.dart' as d;

import 'virash_app_theme.dart';
import 'globals.dart';
import 'models/tabIcon_data.dart';
import 'my_diary/homescreen.dart';

class TaskNav extends StatefulWidget {
  TaskNav({Key? key,required this.id,required this.name}) : super(key: key);
  bool isLoading = false;
  String id,name;
  @override
  _TaskNavState createState() => _TaskNavState();
}

class _TaskNavState extends State<TaskNav>
    with TickerProviderStateMixin {
  AnimationController? animationController;


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
    List<Widget> _widgetOptions=[] ;



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


  List<TabIconData> tabIconsList = TabIconData.tasktabIconsList;
  Widget tabBody = Container(
    color: VirashAppTheme.background,
  );

  @override
  void initState() {
    _widgetOptions = <Widget>[
      Taskadd(empid: widget.id, name: widget.name,),
      EmpTask(emoid: widget.id, status: 'Pending', fun: (){},name: widget.name, check: 'A',),
      ApprovedTask(emoid: widget.id, name: widget.name,),
      EmpTask(emoid: widget.id, status: 'Rejected', fun: (){},name: widget.name, check: 'A',),
      apptask(emoid: widget.id, name: widget.name,),
    ];


    d.isLoading=true;
    checkinternet();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = Taskadd(empid: widget.id, name: widget.name,);
    super.initState();
  }
  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  var  h=MediaQuery.of(context).size.height;
    return Container(
      color: VirashAppTheme.background,
      child: net?Scaffold(
        backgroundColor: Colors.transparent,
        body: widget.isLoading?Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                color: Colors.lightBlue,
              ),
              SizedBox(
                height: 10.0,
              ),
              CircularProgressIndicator(color: Colors.lightBlue,)
            ],
          ),
        ):
        FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Scaffold(
                body: SafeArea(
                  child: Center(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  ),
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(.1),
                      )
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,10,0,10),
                      child: GNav(
                        rippleColor: Colors.grey[300]!,
                        hoverColor: Colors.grey[100]!,
                        gap: 8,
                        activeColor: Colors.black,
                        iconSize: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        duration: const Duration(milliseconds: 400),
                        tabBackgroundColor: Colors.grey[100]!,
                        color: Colors.black,
                        tabs:   [
                          GButton(
                            iconColor: Colors.cyan,
                            iconActiveColor: Color(0xff343BA8),
                            textColor: Color(0xff343BA8),
                            backgroundColor: Color(0xffcad9fa),
                            onPressed: (){
                              d.isLoading=true;

                            },
                            icon: Icons.add_circle,
                            text: 'Add',
                          ),
                           const GButton(
                            iconActiveColor: Color(0xffd16506),
                            textColor: Color(0xffd16506),
                            backgroundColor: Color(0xfff7d7b5),
                            icon: Icons.pending,
                            text: 'Pending',

                          ),
                          GButton(
                            iconActiveColor: Color(0xff1B632A),
                            textColor: Color(0xff1B632A),
                            backgroundColor: Color(0xffa6ffb5),
                            onPressed: (){
                              d.isLoading=true;
                            },
                            icon: Icons.check_circle,
                            text: 'Completed',
                          ),
                            const GButton(
                            iconActiveColor: Color(0xffad1c11),
                            textColor: Color(0xffad1c11),
                            backgroundColor: Color(0xffF7ADA8),
                            icon: Icons.cancel,
                            text: 'Rejected',
                          ),
                           GButton(
                             iconActiveColor: Color(0xff0550b5),
                             textColor: Color(0xff0550b5),
                             backgroundColor: Color(0xffa6ccff),
                             onPressed: (){
                               d.isLoading=true;
                             },
                            icon:  Icons.thumb_up,
                            text: 'Approved',
                          ),
                        ],
                        selectedIndex: _selectedIndex,
                        onTabChange: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                )


              );
            }
          },
        ),
      ):Scaffold(
        body: SafeArea(
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
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
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


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return TaskBottomBarView(
      tabIconsList: tabIconsList,
      addClick: () {
        setState(() {
          widget.isLoading=true;
        });
      },
      changeIndex: (int index) {
        if (index == 0 ) {
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            d.isLoading=true;
            setState(() {
              tabBody =
                  Taskadd(empid: widget.id, name: widget.name,);
            });
          });
        } else if (index == 1 ) {
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }

            setState(() {
              tabBody =
                  EmpTask(emoid: widget.id, status: 'Pending', fun: (){},name: widget.name, check: 'A',);
            });
          });
        }else if (index == 2 ){
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              d.isLoading=true;
              tabBody =
                  ApprovedTask(emoid: widget.id, name: widget.name,);
                  // EmpTask(emoid: widget.id, status: 'complete',);
                 // CompTask(emoid: widget.id);
            });
          });
        }else if (index == 3 ){
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody =
                  EmpTask(emoid: widget.id, status: 'Rejected', fun: (){},name: widget.name, check: 'A',);
              //CompTask(emoid: widget.id);
            });
          });
        }else if (index == 4 ){
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            d.isLoading=true;
            setState(() {
              tabBody =
                  apptask(emoid: widget.id, name: widget.name,);
                  //CompTask(emoid: widget.id);
            });
          });
        }
      },
    );
  }
}
