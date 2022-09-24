import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'globals.dart';

class tasklist extends StatefulWidget {
   tasklist({Key? key,required this.id }) : super(key: key);
  String id;
  @override
  State<tasklist> createState() => _tasklistState();
}

class _tasklistState extends State<tasklist> {
  fetchtasklist() async {
    print(userId);
    Dio dio=Dio();
    var formData = FormData.fromMap({
      "emp_id":widget.id
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/employeeAllTask', data: formData);
    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      return response.data;
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title:Text("VIEW EMPLOYE")),
        body:FutureBuilder<dynamic>(
          future: fetchtasklist(), // async work
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Center(child: Text('Loading....'));
              default:
                if (snapshot.hasError)
                  return SafeArea(child:Text('Error: ${snapshot.error}'));
                else {
                  Color primaryColor = const Color(0xff1f7396);
                  return   snapshot.data["success"].toString().trim()=="1"?
                  ListView.builder(
                    itemCount: snapshot.data["data"].length,
                    itemBuilder: (context, position) {
                      return InkWell(
                        onTap:()=>{
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(snapshot.data["data"][position]["emp_name"]),
                            ),
                          ),
                        ),


                      );


                    },
                  ):Image.asset("assets/no_data.png");
                }
            }
          },
        )

    );
  }
}
