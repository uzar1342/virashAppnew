import 'package:flutter/material.dart';

import 'TodayBatch.dart';
import 'globals.dart';
import 'emptask.dart';
class EmpTaskNav extends StatelessWidget {
  const EmpTaskNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(25.0)
                    ),
                    child:  TabBar(
                      indicator: BoxDecoration(
                          color: primaryColor,
                          borderRadius:  BorderRadius.circular(25.0)
                      ) ,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const  [
                        Tab(text: 'Pending',),
                        Tab(text: 'Completed',),
                        Tab(text: 'Rejected',),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                        children:  [
                        EmpTask(emoid: userId, status: 'Pending',),
                          EmpTask(emoid: userId, status: 'Completed',),
                          EmpTask(emoid: userId, status: 'Rejected',),
                        ],
                      )
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}