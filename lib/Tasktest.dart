import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/src/form_data.dart';
import 'package:get/get.dart' as hi;



import 'globals.dart';

class testTaskadd extends StatefulWidget {
  testTaskadd({Key? key}) : super(key: key);

  @override
  State<testTaskadd> createState() => _testTaskaddState();
}

class _testTaskaddState extends State<testTaskadd> {
  List<dynamic> employelist = [];
  bool isLoading=false;
  String employeName="";
  var arr = [];
  var empid=null;
  var data=[];
  String? f;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  Sendtask(task) async {
    print(userId);
    Dio dio=new Dio();
    var response = await dio.post('http://training.virash.in/provide_task', data: task);
    if (response.statusCode == 200) {
      print(response.data.length);
      Fluttertoast.showToast(msg: "Sucessfull Send");
    } else {
      Fluttertoast.showToast(msg: "Unable to fetch bank list");
      setState(() {
        isLoading = false;
      });
    }
  }





  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // showemployelistDialog() {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         double h = MediaQuery.of(context).size.height;
    //         double w = MediaQuery.of(context).size.width;
    //         return Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Container(
    //             height: h * 0.6,
    //             width: w * 0.9,
    //             child: AlertDialog(
    //               title: Text("Employe",
    //                   style: TextStyle(
    //                       color: primaryColor, fontWeight: FontWeight.bold)),
    //               content: Container(
    //                 height: h * 0.5,
    //                 width: w,
    //                 child: ListView.builder(
    //                   shrinkWrap: false,
    //                   itemCount: employelist.length,
    //                   itemBuilder: (BuildContext context, int index) {
    //                     return InkWell(
    //                       onTap: () {
    //                         setState(() {
    //                           print(employelist.first);
    //                           employeName = employelist[index]['emp_name'];
    //                           empid = employelist[index]['emp_id'];
    //
    //                         });
    //                         Navigator.pop(context);
    //                       },
    //                       child: Container(
    //                         margin: EdgeInsets.all(5.0),
    //                         child: Card(
    //                           child: Container(
    //                               padding: EdgeInsets.all(10.0),
    //                               child: Text(employelist[index]['emp_name'])),
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ),
    //         );
    //       });
    // }
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;
    TextEditingController taskcontroler=new TextEditingController();
    return Scaffold(
        appBar: AppBar(title: Text("Add Task"),),
        body: SafeArea(

            child: Container(child:
            Column(children: <Widget>[
              // SizedBox(
              //   height: h * 0.03,
              // ),
              // Text(
              //   "Please select Employe name from below",
              //   style:
              //   TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: h * 0.01,
              // ),
              // InkWell(
              //   onTap: () {
              //     showemployelistDialog();
              //   },
              //   child: Container(
              //     width: w * 0.95,
              //     child: Card(
              //       child: Container(
              //         padding: EdgeInsets.all(10.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Row(
              //               children: [
              //                 Icon(
              //                   Icons.person,
              //                   color: Colors.black45,
              //                 ),
              //                 SizedBox(
              //                   width: w * 0.03,
              //                 ),
              //                 Container(
              //                   width: w * 0.7,
              //                   child: Text(
              //                     employeName,
              //                     style: TextStyle(
              //                       color: Colors.black54,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 )
              //               ],
              //             ),
              //             Icon(
              //               Icons.keyboard_arrow_down,
              //               color: Colors.black45,
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity - 50,
                        child: DropdownButtonFormField<String>(
                          key: _key,
                          isExpanded: false,
                          items: [
                            buildMenuItem("low"),
                            buildMenuItem("mediam"),
                            buildMenuItem("high"),
                          ],
                          onChanged: (value) => setState(() {
                            f=value;
                          }),
                          value: f,
                          hint: const Text(
                            "Select Priority",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(12),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: "Priority",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: taskcontroler,
                      maxLines:2,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.assignment,
                            color: Colors.red.shade200,
                          ),
                          hintText: "Task",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            gapPadding: 9,
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                                Radius.circular(12.0)),
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0)),
                    ),
                  ],
                ),
              ),
              ), Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity - 50,
                        child: DropdownButtonFormField<String>(
                          key: _key,
                          isExpanded: false,
                          items: [
                            buildMenuItem("low"),
                            buildMenuItem("mediam"),
                            buildMenuItem("high"),
                          ],
                          onChanged: (value) => setState(() {
                            f=value;
                          }),
                          value: f,
                          hint: const Text(
                            "Select Priority",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(12),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: "Priority",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: taskcontroler,
                      maxLines:2,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.assignment,
                            color: Colors.red.shade200,
                          ),
                          hintText: "Task",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            gapPadding: 9,
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                                Radius.circular(12.0)),
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0)),
                    ),
                  ],
                ),
              ),
              )
              ,ElevatedButton(onPressed: (){



                if(taskcontroler.value.text!="")
                {
                  if(f!=null) {

                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Task Detail'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text("Task :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w100),),
                                Text(taskcontroler.value.text,style:TextStyle(fontSize: 15,fontWeight: FontWeight.w100))
                              ],),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text("priorety :",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w100),),
                                Text(f.toString(),style:TextStyle(fontSize: 15,fontWeight: FontWeight.w100))
                              ],),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () =>
                            {
                              data.add({"task":taskcontroler.value.text,"priority":f}),
                              _key.currentState?.reset(),
                              taskcontroler.clear(),
                              Navigator.pop(context, 'OK')},
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );

                  }
                  else
                  {
                    Fluttertoast.showToast(msg: "sellect Priorety");
                  }
                }
                else
                {
                  Fluttertoast.showToast(msg: "Fill Task");
                }

              }, child: Text("Add Task"))

              ,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      if(employeName!=""&&empid!=null)
                      {
                        if(data.length>0)
                        {
                          Sendtask({"emp_id":userId,"assigned_to":empid,"tasks":data});
                        }
                        else
                        {
                          Fluttertoast.showToast(msg: "Task is not Add");
                        }
                      }
                      else
                      {
                        Fluttertoast.showToast(msg: "Select Employe");
                      }
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.navigation),
                  ),
                ),
              ),

            ])
            )));




  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

}
