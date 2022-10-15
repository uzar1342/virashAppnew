import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'TodayBatch.dart';
import 'globals.dart';
import 'emptask.dart';
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
                                  padding: EdgeInsets.all(8.0),
                                  child: Text( 'Pending',),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(pend.toString(),style: TextStyle(fontSize: 15),),
                                  ),
                                ),
                              ],
                            ),
                            comp>9?Row(
                              children:  <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text( 'Completed',style: TextStyle(fontSize: 11),),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(comp.toString(),style: TextStyle(fontSize: 13),),
                                  ),
                                ),
                              ],
                            ):
                            Row(
                              children:  <Widget>[
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text( 'Completed',),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(comp.toString(),style: TextStyle(fontSize: 15),),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children:  <Widget>[
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text( 'Rejected',),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(rej.toString(),),
                                  ),
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