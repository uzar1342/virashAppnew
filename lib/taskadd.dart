import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/src/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart'as http;
import 'package:http/http.dart';

import 'globals.dart';

class Taskadd extends StatefulWidget {
   Taskadd({Key? key}) : super(key: key);

 int len=0;
   String val="select priorety";


  @override
  State<Taskadd> createState() => _TaskaddState();
}

class _TaskaddState extends State<Taskadd> {
  List<dynamic> employelist = [];
  bool isLoading=false;
  String employeName="";
  List Priority=[];
  fetchemployelist() async {
    print(userId);
    Dio dio=new Dio();
    final url = Uri.parse("http://training.virash.in/employee_list");

    var formData = FormData.fromMap({
      "emp_id":  userId
    });

    var response = await dio.post('http://training.virash.in/employee_list', data: formData);

    if (response.statusCode == 200) {

      print(response.data.length);
      setState(() {
        employelist = response.data["data"];
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to fetch bank list");
      setState(() {
        isLoading = false;
      });
    }
  }
  Sendtask() async {
    print(userId);
    Dio dio=new Dio();
    var response = await dio.post('http://training.virash.in/provide_task', data: {"emp_id":3,"assigned_to":1,"tasks":[{"task":"this is dummy task 1","priority":"medium"},{"task":"this is dummy task 2","priority":"low"},{"task":"this is dummy task 3","priority":"high"}]});
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
    fetchemployelist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List _listings = [];
    showemployelistDialog() {
      showDialog(
          context: context,
          builder: (context) {
            double h = MediaQuery.of(context).size.height;
            double w = MediaQuery.of(context).size.width;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: h * 0.6,
                width: w * 0.9,
                child: AlertDialog(
                  title: Text("Employe",
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold)),
                  content: Container(
                    height: h * 0.5,
                    width: w,
                    child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: employelist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              print(employelist.first);
                              employeName = employelist[index]['emp_name'];
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: Card(
                              child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(employelist[index]['emp_name'])),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          });
    }
var w=MediaQuery.of(context).size.width;
var h=MediaQuery.of(context).size.height;
var f="low";

    List<Widget> _getListings() {// <<<<< Note this change for the return type
      List<Widget> listings = <Widget>[];
      int i = 0;

      for (i = 0; i < widget.len; i++) {
        listings.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity - 50,
                      child: DropdownButtonFormField<String>(
                        isExpanded: false,
                        items: [
                          buildMenuItem("low"),
                          buildMenuItem("mediam"),
                          buildMenuItem("high"),
                        ],
                        onChanged: (value) => ()
                        {
                          Priority.add(value);
                          print(Priority.length);
                          setState(() {
                            f=value!;


                          });
                        },
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
                    maxLines:2,
                    onChanged: (text) {
                      setState(() {});
                    },
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.assignment,
                          color: Colors.red.shade200,
                        ),
                        hintText: "Remark",
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
            )
        );
      }
      return listings;
    }


    return Scaffold(
appBar: AppBar(title: Text("Add Task"),),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(Priority);
            setState(() {
              widget.len=widget.len+1;
            });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.navigation),
        ),
        body: SafeArea(

        child: Container(child: Column(children: <Widget>[
          SizedBox(
            height: h * 0.03,
          ),
          Text(
            "Please select Employe name from below",
            style:
            TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: h * 0.01,
          ),
          InkWell(
            onTap: () {
              showemployelistDialog();
            },
            child: Container(
              width: w * 0.95,
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: w * 0.03,
                          ),
                          Container(
                            width: w * 0.7,
                            child: Text(
                              employeName,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black45,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          Expanded(child:  ListView(
            padding: const EdgeInsets.all(20.0),
            children: _getListings(), // <<<<< Note this change for the return type
          ),

          )
          ,ElevatedButton(onPressed: (){
          }, child: Text("Send Task"))
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
