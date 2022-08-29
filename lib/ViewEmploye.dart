import 'package:Virash/tasknav.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'fitness_app_home_screen.dart';
import 'globals.dart';

class viewemp extends StatefulWidget {
  const viewemp({Key? key}) : super(key: key);

  @override
  State<viewemp> createState() => _viewempState();
}


class _viewempState extends State<viewemp> {
 bool isLoading=true;
  fetchemployelist() async {
    print(userId);
    Dio dio=Dio();


    var formData = FormData.fromMap({
      "emp_id":userId
    });
print(formData.fields);
    var response = await dio.post('http://training.virash.in/employee_list', data: formData);
    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
      setState(() {
        isLoading = false;
      });
    } else {
      return response.data;
      Fluttertoast.showToast(msg: "Unable to fetch bank list");
      setState(() {
        isLoading = false;
      });
    }
  }
@override
  void initState() {
  fetchemployelist();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("VIEW EMPLOYE")),
      body:FutureBuilder<dynamic>(
        future: fetchemployelist(), // async work
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: Text('Loading....'));
            default:
              if (snapshot.hasError)
                return SafeArea(child:Text('Error: ${snapshot.error}'));
              else {
                Color primaryColor = const Color(0xff1f7396);
                return   snapshot.data["success"].toString().trim()=="1"?ListView.builder(
                  itemCount: snapshot.data["data"].length,
                  itemBuilder: (context, position) {
                    return InkWell(
                      onTap:()=>{
Navigator.push(context, MaterialPageRoute(builder: (c)=>

                     // FitnessAppHomeScreen())
    TaskNav(id: snapshot.data["data"][position]["emp_id"].toString(),))
)},
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
