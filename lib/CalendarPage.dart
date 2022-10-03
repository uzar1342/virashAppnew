import 'package:Virash/viewimage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'OuttimeForm.dart';
import 'globals.dart';
import 'googlemap.dart';
import 'no_internet_page.dart';


class CalendarPage extends StatefulWidget {
   CalendarPage( {required this.id, Key? key,}) : super(key: key);
String id;
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  late int year;
  late int day;
  late int month;
  final DateFormat formatter = DateFormat('dd-MM-yyy');
  bool isLoading = true;
  var subscription;
  bool net = true;
  checkinternet() async {

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          setState(() {
            net = false;
          });
        });
      } else {
        setState(() {
          net = true;
        });
      }
    });
  }

  List<dynamic> calevents = [];
  Map<String, List<dynamic>> events = {};
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  // fetchLectures() async {
  //   final url = Uri.parse(Urls().lectureScheduleUrl);

  //   var body = json.encode([
  //     {
  //       "mobile_number": userPhone,
  //       "student_id": userId,
  //       "course_id": widget.courseId,
  //     }
  //   ]);
  // }



  List<dynamic> _getEventsForDay(DateTime day) {
    final formatted = formatter.format(day);
    return events[formatted] ?? [];
  }



  @override
  void initState() {
    year=DateTime.now().year;
    day=DateTime.now().day;
    month=DateTime.now().month;
    checkinternet();
    final selectedDayFormattedDate = formatter.format(selectedDay);
    _selectedEvents = ValueNotifier(
        _getEventsForDay(formatter.parse(selectedDayFormattedDate)));
    super.initState();
  }



  Future<dynamic> viewattendence()
  async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'year': year.toString(),
      'month': month>=10?month.toString():"0"+month.toString(),
      "day" :   day>=10?day.toString():"0"+day.toString(),
      "role":   employee_role,
      "emp_id":  userId
    });
    print(widget.id);
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/allEmployeesAttendanceDetails', data: formData);
    if(response.statusCode==200)
    {
      print(response.data);
      return response.data;
    }
    else
    {
      print(response.statusCode);
      return response.data ;
    }

  }


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xff1f7396);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: net?SafeArea(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  height: h * 0.09,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            // top: 10.0,
                            left: 15.0,
                          ),
                          //padding: const EdgeInsets.only(left: 5.0),
                          height: h * 0.05,
                          width: h * 0.05,
                          decoration: BoxDecoration(
                            // color: primaryColor,
                              border: Border.all(color: Colors.black26, width: 1.0),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black87,
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        "Time table",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const AttendancePage()));
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.chartArea,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  )),
              //SizedBox(height: h * 0.02),
              Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // TableCalendar(
                      //   focusedDay: focusedDay,
                      //   firstDay: DateTime.utc(2018),
                      //   lastDay: DateTime.now(),
                      //   rowHeight: 60,
                      //   eventLoader: _getEventsForDay,
                      //   startingDayOfWeek: StartingDayOfWeek.monday,
                      //   calendarStyle: CalendarStyle(
                      //     isTodayHighlighted: true,
                      //     todayDecoration: BoxDecoration(
                      //         color: Colors.orange.shade200,
                      //         shape: BoxShape.rectangle,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     selectedDecoration: BoxDecoration(
                      //         color: primaryColor,
                      //         shape: BoxShape.rectangle,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     defaultDecoration: BoxDecoration(
                      //         color: Colors.white,
                      //         shape: BoxShape.rectangle,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     weekendDecoration: BoxDecoration(
                      //         shape: BoxShape.rectangle,
                      //         color: Color(0xffd9d9d9),
                      //         borderRadius: BorderRadius.circular(10)),
                      //     disabledDecoration: BoxDecoration(
                      //         shape: BoxShape.rectangle,
                      //         color: Color(0xffd8d8db),
                      //         borderRadius: BorderRadius.circular(10)),
                      //     holidayDecoration: BoxDecoration(
                      //         shape: BoxShape.rectangle,
                      //         color: Colors.green,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     outsideDecoration: BoxDecoration(
                      //         shape: BoxShape.rectangle,
                      //         color: Colors.grey.shade200,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     markersAnchor: 1.2,
                      //     markersMaxCount: 5,
                      //   ),
                      //   calendarBuilders: CalendarBuilders(
                      //       singleMarkerBuilder: (context, date, event) {
                      //         return Container(
                      //           width: 4,
                      //           height: 4,
                      //           margin: const EdgeInsets.symmetric(horizontal: 0.5),
                      //           decoration: const BoxDecoration(
                      //             color: Colors.amber,
                      //             shape: BoxShape.circle,
                      //           ),
                      //         );
                      //       }),
                      //   //Day Change and focus change
                      //   selectedDayPredicate: (day) {
                      //     return isSameDay(selectedDay, day);
                      //   },
                      //   onDaySelected: (DateTime selectday, DateTime focusDay) {
                      //     print(selectday.day);
                      //     setState(() {
                      //       day=selectday.day;
                      //       month=selectday.month;
                      //       year=selectday.year;
                      //       selectedDay = selectday;
                      //       focusedDay = focusDay;
                      //     });
                      //     _selectedEvents.value = _getEventsForDay(selectday);
                      //   },
                      //   daysOfWeekVisible: true,
                      //   headerStyle: HeaderStyle(
                      //       formatButtonDecoration: BoxDecoration(
                      //           border: Border.all(color: primaryColor, width: 1),
                      //           borderRadius: BorderRadius.circular(15)),
                      //       formatButtonTextStyle: TextStyle(
                      //           color: primaryColor,
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w400),
                      //       titleCentered: true,
                      //       titleTextStyle: TextStyle(
                      //           color: primaryColor,
                      //           fontWeight: FontWeight.w700,
                      //           fontSize: 18),
                      //       leftChevronIcon: Container(
                      //           padding: const EdgeInsets.all(4),
                      //           decoration: BoxDecoration(
                      //             color: Colors.grey.shade300,
                      //             borderRadius:
                      //             const BorderRadius.all(Radius.circular(8)),
                      //           ),
                      //           child: const Icon(
                      //             Icons.chevron_left_outlined,
                      //             color: Colors.grey,
                      //             size: 26,
                      //           )),
                      //       rightChevronIcon: Container(
                      //           padding: const EdgeInsets.all(4),
                      //           decoration: BoxDecoration(
                      //             color: Colors.grey.shade300,
                      //             borderRadius:
                      //             const BorderRadius.all(Radius.circular(8)),
                      //           ),
                      //           child: const Icon(Icons.chevron_right_outlined,
                      //               color: Colors.grey, size: 26)),
                      //       formatButtonVisible: true),
                      //   onPageChanged: (focusedDay) {
                      //     focusedDay = focusedDay;
                      //   },
                      //   //Format of Calendar week month 2weeks
                      //   calendarFormat: CalendarFormat.week,
                      // ),

                    Expanded(
                        child: FutureBuilder<dynamic>(
                          future: viewattendence(), // async work
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
                                    },
                                  child: Container(
                                    child: ValueListenableBuilder<List<dynamic>>(
                                      valueListenable: _selectedEvents,
                                      builder: (context, value, _) {
                                        return
                                          Container(
                                            width: w,
                                            margin: const EdgeInsets.all(5.0),
                                            child: Card(
                                              elevation: 3.0,
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(14.0))),
                                              child:            Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [

                                                          SizedBox(
                                                            width: w * 0.02,
                                                          ),
                                                          Text(
                                                            snapshot.data["data"][position]["emp_name"].toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 16.0),
                                                          )
                                                        ],
                                                      ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          if(snapshot.data["data"][position]["in_latitude"]!="N/A"||snapshot.data["data"][position]["in_longitude"]!="N/A") {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                              Googlem(

                                                                   lan: double.parse(snapshot.data["data"][position]["in_latitude"]), lug: double.parse(snapshot.data["data"][position]["in_longitude"]))));
                                                          } else {
                                                            Fluttertoast.showToast(msg: "No Location found");
                                                          }

                                                          },
                                                        child: Container(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(5.0),
                                                          height: h * 0.04,
                                                          decoration:  BoxDecoration(
                                                              color:  snapshot.data["data"][position]["Presentee"]=="Absent"?Colors
                                                                  .red:Colors
                                                                  .green,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                  .circular(
                                                                  20.0))),
                                                          child: Row(
                                                            children: [
                                                              const FaIcon(
                                                                FontAwesomeIcons
                                                                    .globe,
                                                                color: Colors
                                                                    .white,
                                                                size: 20.0,
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                w * 0.01,
                                                              ),
                                                              Text(
                                                                snapshot.data["data"][position]["Presentee"].toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                  const Divider(),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .access_time_filled,
                                                            color: Colors
                                                                .green.shade200,
                                                          ),
                                                          SizedBox(
                                                            width: w * 0.01,
                                                          ),
                                                          Text(

                                                              snapshot.data["data"][position]["in_time"],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                        ],
                                                      ),
                                                      const Text(
                                                        "To",
                                                        style: TextStyle(
                                                            color: Colors.black38,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .access_time_filled,
                                                            color: Colors
                                                                .red.shade200,
                                                          ),
                                                          SizedBox(
                                                            width: w * 0.01,
                                                          ),
                                                          Text(

                                                              snapshot.data["data"][position]["out_time"].toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Divider(),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .assignment,
                                                        color: Colors
                                                            .red.shade200,
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.01,
                                                      ),
                                                      Container(
                                                        width: w*0.8,
                                                        child: Text(
                                                            snapshot.data["data"][position]["task"]!=null?snapshot.data["data"][position]["task"].toString():"",
                                                            maxLines: 8,style: const TextStyle(
                                                                color: Colors
                                                                    .black54)),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                      viewimage(inimage: snapshot.data["data"][position]["in_image"].toString(), outimage: snapshot.data["data"][position]["out_image"].toString(),)));
                                                        },
                                                        child: Container(
                                                          padding:
                                                          EdgeInsets.all(8.0),
                                                          decoration:
                                                          BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                            const BorderRadius.all(
                                                              Radius.circular(
                                                                  14.0),
                                                            ),
                                                          ),
                                                          child: Row(children: const [
                                                            Icon(
                                                              Icons.assignment,
                                                              color: Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            Text(
                                                              "View Image",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                      snapshot.data["data"][position]["out_time"]==null?SizedBox(width: 10,):Container(),
                                                      snapshot.data["data"][position]["out_time"]==null?  Container(
                                                        child: employee_role=="Admin"||employee_role=="Super Admin"||employee_role=="Faculty & Admin"?
                                                        widget.id!=snapshot.data["data"][position]["emp_id"].toString().trim()?Container(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                          DateTimePicker(id: widget.id, date: "${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}",)
                                                                  ));
                                                            },
                                                            child: Container(
                                                              padding:
                                                              EdgeInsets.all(8.0),
                                                              decoration:
                                                              BoxDecoration(
                                                                color: primaryColor,
                                                                borderRadius:
                                                                const BorderRadius.all(
                                                                  Radius.circular(
                                                                      14.0),
                                                                ),
                                                              ),
                                                              child: Row(children: const [
                                                                Icon(
                                                                  Icons.punch_clock_rounded,
                                                                  color: Colors.white,
                                                                ),
                                                                SizedBox(
                                                                  width: 5.0,
                                                                ),
                                                                Text(
                                                                  "Mark Outtime",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                )
                                                              ]),
                                                            ),
                                                          ),
                                                        ):Container():Container(),
                                                      ):Container(),
                                                    ],
                                                  )
                                                ],
                                              ),


                                            ),
                                          );


                                      },
                                    )
                                    ,
                                  ),


                                );


                              },
                            ):Image.asset("assets/no_data.png");
            }
        }
      },
                      )  ),
                    ],
                  )),
            ],
          )):SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/no_internet.png",
                height: 300,
                width: 300,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  "Looks like you got disconnected, Please check your Internet connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          )),
    );
  }
}





