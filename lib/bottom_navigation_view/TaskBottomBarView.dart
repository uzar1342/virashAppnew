import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../virash_app_home_screen.dart';
import '../virash_app_theme.dart';
import '../globals.dart';
import '../mark_attendence.dart';
import '../models/tabIcon_data.dart';
import '../shared_prefs_keys.dart';

class TaskBottomBarView extends StatefulWidget {
  const TaskBottomBarView(
      {Key? key, this.tabIconsList, this.changeIndex, this.addClick})
      : super(key: key);

  final Function(int index)? changeIndex;
  final Function()? addClick;
  final List<TabIconData>? tabIconsList;

  @override
  _TaskBottomBarViewState createState() => _TaskBottomBarViewState();
}

class _TaskBottomBarViewState extends State<TaskBottomBarView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  bool isLoading = false;
  bool net = false;
  String Address='';


  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(
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
    ):Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return PhysicalShape(
              color: VirashAppTheme.white,
              elevation: 16.0,
              clipper: TabClipper(
                  radius: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                      parent: animationController!,
                      curve: Curves.fastOutSlowIn))
                      .value ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 62,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 8, right: 8, top: 4),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TabIcons(
                                tabIconData: widget.tabIconsList?[0],
                                removeAllSelect: () {
                                  setRemoveAllSelection(
                                      widget.tabIconsList?[0]);
                                  widget.changeIndex!(0);
                                }),
                          ),
                          Expanded(
                            child: TabIcons(
                                tabIconData: widget.tabIconsList?[1],
                                removeAllSelect: () {
                                  setRemoveAllSelection(
                                      widget.tabIconsList?[1]);
                                  widget.changeIndex!(1);
                                }),
                          ),
                          SizedBox(
                            width: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                parent: animationController!,
                                curve: Curves.fastOutSlowIn))
                                .value *
                                64.0,
                          ),
                          Expanded(
                            child: TabIcons(
                                tabIconData: widget.tabIconsList?[2],
                                removeAllSelect: () {
                                  setRemoveAllSelection(
                                      widget.tabIconsList?[2]);
                                  widget.changeIndex!(2);
                                }),
                          ),
                          Expanded(
                            child: TabIcons(
                                tabIconData: widget.tabIconsList?[3],
                                removeAllSelect: () {
                                  setRemoveAllSelection(
                                      widget.tabIconsList?[3]);
                                  widget.changeIndex!(3);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ],
    );
  }











  void setRemoveAllSelection(TabIconData? tabIconData) {
    if (!mounted) return;
    setState(() {
      widget.tabIconsList?.forEach((TabIconData tab) {
        tab.isSelected = false;
        if (tabIconData!.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }
}

class TabIcons extends StatefulWidget {
  const TabIcons({Key? key, this.tabIconData, this.removeAllSelect})
      : super(key: key);

  final TabIconData? tabIconData;
  final Function()? removeAllSelect;
  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData?.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        widget.removeAllSelect!();
        widget.tabIconData?.animationController?.reverse();
      }
    });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData?.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData!.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.tabIconData!.animationController!,
                          curve:
                          Interval(0.1, 1.0, curve: Curves.fastOutSlowIn))),
                  child: Column(
                    children: [
                      Image.asset(widget.tabIconData!.isSelected
                          ? widget.tabIconData!.selectedImagePath
                          : widget.tabIconData!.imagePath),
                      Text(widget.tabIconData!.lable)
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: Interval(0.2, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 0,
                      height: 0,
                      decoration: BoxDecoration(
                        color: VirashAppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 6,
                  bottom: 8,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: Interval(0.5, 0.8,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: VirashAppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 8,
                  bottom: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: Interval(0.5, 0.6,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: VirashAppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 0});

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(0),
        degreeToRadians(0), false);
    path.arcTo(
        Rect.fromLTWH(
            ((0) - 0) - 0 + 0 * 0, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((0) - 0, 0, 0, 0),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH(0, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double redian = (math.pi / 180) * degree;
    return redian;
  }
}
