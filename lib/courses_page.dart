import 'dart:convert';
import 'package:Virash/subcourses.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';


import 'all_resources_page.dart';
import 'Module.dart';
import 'configs/globals.dart' as g;
import 'configs/urls.dart';
import 'globals.dart';


class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool isLoading = true;
  bool showSearch = false;

  var studentCourseList ;
  final TextEditingController _searchController = TextEditingController();
 Future<dynamic> fetchCourseList()  async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'data':"all_courses"
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/get_courses', data:formData);
    if (response.statusCode == 200) {
      setState(() {
        studentCourseList=response.data;
        isLoading = false;
      });
      print(response.data);
    } else {
      print(response.statusCode);
      Fluttertoast.showToast(msg: "Please try again later");
      setState(() {
        isLoading = false;
      });
    }
  }




  @override
  void initState() {
    fetchCourseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: h * 0.35,
                        ),
                        SpinKitFadingCube(
                          color: primaryColor,
                        ),
                        // CircularProgressIndicator(
                        //   color: primaryColor,
                        // ),
                        // SizedBox(
                        //   height: 10.0,
                        // ),
                        // Text("Loading...")
                      ],
                    ),
                  )
                : Column(
                    children: [
                      showSearch
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: w * 0.7,
                                  child: Card(
                                    //margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                                    elevation: 4,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: TextFormField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: Colors.orange.shade200,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.black38,
                                              size: 20.0,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _searchController.clear();
                                              });
                                            },
                                          ),
                                          hintText: "Search",
                                          hintStyle: const TextStyle(
                                              color: Colors.black26),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18.0)),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 16.0)),
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showSearch = false;
                                        _searchController.clear();
                                      });
                                    },
                                    child: Text("Close",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          decoration: TextDecoration.underline,
                                        ))),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Hello,",
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 18.0),
                                    ),
                                    Text(
                                      employee_name,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26.0),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showSearch = true;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.search,
                                          color: primaryColor,
                                        )),
                                    IconButton(
                                        onPressed: () {

                                        },
                                        icon: Icon(
                                          Icons.notifications,
                                          color: primaryColor,
                                          size: 25,
                                        ))
                                  ],
                                )
                              ],
                            ),
                      SizedBox(
                        height: h * 0.02,
                      ),

                      SizedBox(
                        height: h * 0.03,
                      ),
                      Row(
                        children: [
                          const Text(
                            "My Enrolled Courses",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: primaryColor,
                            size: 30.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      studentCourseList["data"].isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/no_data.png",
                                    height: 300,
                                    width: 300,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "No Courses Found",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.00),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                        shrinkWrap: true,
                              primary: false,
                              itemCount: studentCourseList["data"].length,
                              //physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (studentCourseList["data"][index]['course_name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase())) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SubCoursesPage(
                                                id: studentCourseList["data"][index]["course_id"].toString(),
                                              )));
                                    },
                                    child: Container(
                                      height: h * 0.1,
                                      width: w,
                                      decoration: BoxDecoration(
                                          color: index % 2 == 0
                                              ? Colors.pink.withOpacity(0.1)
                                              : Colors.blue.withOpacity(0.1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12.0))),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: h * 0.06,
                                                width: h * 0.06,
                                                decoration: const BoxDecoration(
                                                  // image: DecorationImage(
                                                  //     image: NetworkImage(
                                                  //         studentCourseList[
                                                  //                 index]
                                                  //             ['thumbnail']),
                                                  //     fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12.0),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(14.0),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          studentCourseList["data"][index]
                                                              ['image'],
                                                      placeholder:
                                                          (context, url) =>
                                                              SpinKitChasingDots(
                                                        color: primaryColor,
                                                      ),
                                                      errorWidget: (context, url,
                                                              error) =>
                                                          const Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [

                                                  Container(
                                                    width: 300,
                                                    child: RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      strutStyle: StrutStyle(fontSize: 17.0),
                                                      text: TextSpan(
                                                          style:  const TextStyle(
                                                              color: Colors.black87,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            fontSize: 18
                                                             ),
                                                          text: studentCourseList["data"][index]
                                                          ['course_name']),
                                                    ),
                                                  )
                                                  ,
                                                  Row(
                                                    children: [
                                                      Text(
                                                        studentCourseList["data"][index]
                                                            ['course_duration'].toString()+" hour",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black38,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13.0),
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.01,
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.01,
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.teal.shade200,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              })
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
