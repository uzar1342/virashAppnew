import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'TodayBatch.dart';
import 'globals.dart';
import 'emptask.dart';
import 'emptask.dart'as d;

class EmpTaskNav extends StatelessWidget  {
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
int rej=0,comp=0,pend=0;
bool isLoading=true;

refress()
{
  rej=0;comp=0;pend=0;
  fetchemployetask();
}

  fetchemployetask() async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "emp_id":userId
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/employeeAllTask', data: formData);
    if (response.statusCode == 200) {

      print(response.data["data"]);

      if(response.data["data"]!=null)
      {
        int len=int.parse(response.data["data"].length.toString());
        for(int i=0;i<len;i++)
        {
          if (response.data["data"][i]["status"] == "Rejected") {rej++;}
          if (response.data["data"][i]["status"] == "Completed") {comp++;}
          if (response.data["data"][i]["status"] == "Pending") {pend++;}
        }
      }
      setState(() {
        isLoading = false;
      });

      print(check);print(rej+comp+pend);

      print(response.data);

    } else {
      final snackBar = SnackBar(
        margin: EdgeInsets.only(bottom: 100.0),
        content: const Text('Unable to fetch bank list'),
        backgroundColor: (primaryColor),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    d.isLoading=true;
    fetchemployetask();
    super.initState();
  }
int index=0;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomInset:false,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      height: h * 0.09,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Task Status",
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ],
                      )),
                  !isLoading? Column(
                     children: [
                       Container(
                         width: w,
                        height: 45,
                        child:  TabBar(
                          onTap: (i){
                            d.isLoading=true;
                            setState(() {
                              index=i;
                            });
                          },
                          indicator: BoxDecoration(
                              color: primaryColor,
                          ) ,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Row(
                              children:  <Widget>[
                                 const Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text( 'Pending',),
                                ),
                                Padding(
                           padding: EdgeInsets.only(left: 2),
                           child: Container(
                               height: 20,
                               width: 20,
                               decoration: BoxDecoration(
                                 color: index!=0?primaryColor:Colors.white,
                                 borderRadius: BorderRadius.circular(10),
                               ),

                               child: Center(child: Text(pend.toString(),style: TextStyle(fontSize: 15,color:index==0?primaryColor:Colors.white)))),
                         ),
                              ],
                            ),
                            Row(
                              children:  <Widget>[
                                const Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text( 'Completed',style: TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: index!=1?primaryColor:Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                       child: Center(child: Text(comp.toString(),style: TextStyle(fontSize: 15,color:index==1?primaryColor:Colors.white)))),
                                       ),
                              ],
                            ),
                            Row(
                              children:  <Widget>[
                                const Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text( 'Rejected',),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2),
                                  child: Container(
                                    height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: index!=2?primaryColor:Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                      child: Center(child: Text(rej.toString(),style: TextStyle(fontSize: 15,color:index==2?primaryColor:Colors.white)))),
                                ),
                              ],
                            ),
                          ],
                        ),
                  ),
                  SingleChildScrollView(
                        child: Container(
                          height: h*0.72,
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children:  [
                            EmpTask(emoid: userId, status: 'Pending', fun: ()=>{refress()},),
                              EmpTask(emoid: userId, status: 'Completed', fun: ()=>refress(),),
                              EmpTask(emoid: userId, status: 'Rejected', fun: ()=> refress(),),
                            ],
                          ),
                        ),
                  ),
                     ],
                   ):Center(child: CircularProgressIndicator())
                ],
              ),
            ),
          )
      ),
    );
  }
}