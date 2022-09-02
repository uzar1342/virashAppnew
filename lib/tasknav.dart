import 'package:Virash/taskadd.dart';
import 'package:Virash/training/training_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Tasktest.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'bottom_navigation_view/tasknav.dart';
import 'completetask.dart';
import 'emptask.dart';
import 'virash_app_theme.dart';
import 'globals.dart';
import 'models/tabIcon_data.dart';
import 'my_diary/homescreen.dart';

class TaskNav extends StatefulWidget {
  TaskNav({Key? key,required this.id}) : super(key: key);
  bool isLoading = false;
  String id;
  @override
  _TaskNavState createState() => _TaskNavState();
}

class _TaskNavState extends State<TaskNav>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = Container(
    color: VirashAppTheme.background,
  );


  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = testTaskadd(empid: widget.id,);
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
      child: Scaffold(
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
                  testTaskadd(empid: widget.id);
            });
          });
        } else if (index == 1 || index == 3) {
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
                  EmpTask(emoid: widget.id, status: 'Rejected',);
                  //CompTask(emoid: widget.id);
            });
          });
        }
      },
    );
  }
}
