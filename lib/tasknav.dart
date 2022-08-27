import 'package:Virash/ViewEmploye.dart';
import 'package:Virash/taskadd.dart';
import 'package:Virash/tasklist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_navigation_view/bottom_bar_view.dart';
import 'bottom_navigation_view/tasknav.dart';
import 'fitness_app_theme.dart';
import 'globals.dart';
import 'models/tabIcon_data.dart';

class TaskNav extends StatefulWidget {
   TaskNav({Key? key,required this.id}) : super(key: key);
  bool isLoading = false;
  String id;
  @override
  State<TaskNav> createState() => _TaskNavState();
}

class _TaskNavState extends State<TaskNav> {
  List<TabIconData> tabIconsList = TabIconData.tasktabIconsList;
  Widget
  tabBody =Taskadd();
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
      ):Column(
        children: <Widget>[
          Expanded(flex: 12,child: tabBody),
          Expanded(flex: 1,child:bottomBar()),
        ],
      )
    );
  }
  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(child:TaskBottomBarView(
            tabIconsList: tabIconsList,
            addClick: () {
              setState(() {
                widget.isLoading=true;
              });
            },
            changeIndex: (int index) {
              if (index == 0 || index == 2) {
                  setState(() {
                    tabBody =
                        Taskadd();
                  });

              } else if (index == 1 || index == 3) {
                  setState(() {
                    tabBody =
                        tasklist(id: widget.id,);
                  });

              }
            },
          )),
        ),
      ],
    );
  }
}
