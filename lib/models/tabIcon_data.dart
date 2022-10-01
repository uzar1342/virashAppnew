import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
    this.lable=""
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  String lable;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'asset/hhome.png',
      selectedImagePath: 'asset/home.png',
      index: 0,
      isSelected: true,
      lable: "Home",
      animationController: null,
    ),
    TabIconData(
      imagePath: 'asset/mortarboa.png',
      selectedImagePath: 'asset/mortarboard.png',
      index: 1,
      lable: "",
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'asset/hchecklist.png',
      selectedImagePath: 'asset/checklist.png',
      index: 2,
      lable: "",
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'asset/hcalendar.png',
      selectedImagePath: 'asset/calendar.png',
      index: 3,
      lable: "",
      isSelected: false,
      animationController: null,
    ),
  ];
  static List<TabIconData> tasktabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/plus.png',
      selectedImagePath: 'assets/plus.png',
      index: 0,
      lable: "Add Task",
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/file.png',
      selectedImagePath: 'assets/file.png',
      index: 1,
      lable: "pending",
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/completed-task.png',
      selectedImagePath: 'assets/completed-task.png',
      index: 2,
      lable: "completed",
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/say_no.png',
      selectedImagePath: 'assets/say_no.png',
      index: 3,
      lable: "rejected",
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_4.png',
      selectedImagePath: 'assets/fitness_app/tab_4s.png',
      index: 4,
      isSelected: false,
      animationController: null,
    ),
  ];
  static List<TabIconData> emptabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/file.png',
      selectedImagePath: 'assets/file.png',
      index: 1,
      lable: "pending",
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/completed-task.png',
      selectedImagePath: 'assets/completed-task.png',
      index: 2,
      lable: "completed",
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/say_no.png',
      selectedImagePath: 'assets/say_no.png',
      index: 3,
      lable: "rejected",
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/tab_4.png',
      selectedImagePath: 'assets/fitness_app/tab_4s.png',
      index: 4,
      lable: "Na",
      isSelected: false,
      animationController: null,
    ),
  ];
}
