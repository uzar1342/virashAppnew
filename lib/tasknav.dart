import 'package:Virash/training/training_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'taskAdd.dart';
import 'approved_task.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'bottom_navigation_view/TaskBottomBarView.dart';
import 'completetask.dart';
import 'emptask.dart';
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
    checkinternet();
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = Taskadd(empid: widget.id,);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    subscription.cancle;
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
            children: [
              CircularProgressIndicator(
                color: primaryColor,
              ),
              SizedBox(
                height: 10.0,
              ),
              CircularProgressIndicator()
            ],
          ),
        ):
        FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return SingleChildScrollView(
                child:Column(
                  children: [
                    Container(
                      height: h*0.9,
                        child: tabBody),
                    Container(
                        height: h*0.1,
                        child: bottomBar()),
                  ],) ,
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
            setState(() {
              tabBody =
                  Taskadd(empid: widget.id);
            });
          });
        } else if (index == 1 ) {
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
              tabBody =
                  EmpTask(emoid: widget.id, status: 'Pending',);
            });
          });
        }else if (index == 2 ){
          animationController?.reverse().then<dynamic>((data) {
            if (!mounted) {
              return;
            }
            setState(() {
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
                  EmpTask(emoid: widget.id, status: 'Rejected',);
                  //CompTask(emoid: widget.id);
            });
          });
        }
      },
    );
  }
}
