import 'dart:developer';

import 'package:Virash/viewimage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:table_calendar/table_calendar.dart';
import 'OuttimeForm.dart';
import 'flutter_flow/flutter_flow_theme.dart';
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
  TextEditingController? textController1;
  TextEditingController? textController2;
  late int year;
  late int day;
  late int month;
  String address="";
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

  getLat(Position position)
  async {
    log(address);
  }
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    textController1 = TextEditingController();
    textController1?.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute,DateTime.now().second),
        [h, ':', nn, " ", am]).toString();
    textController2 = TextEditingController();
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
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        textController1?.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [h, ':', nn, " ", am]).toString();
      });
    }
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
                        child: LoaderOverlay(
                          child: FutureBuilder<dynamic>(
                            future: viewattendence(), // async work
                             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                             switch (snapshot.connectionState) {
                              case ConnectionState.waiting: return Center(child: Text('Loading....'));
                              default:
                              if (snapshot.hasError) {
                                return SafeArea(
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors
                                        .white,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "asset/somthing_went_wrong.png",
                                          height: 300,
                                          width: 300,
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                                          child: const Text(
                                            "somthing went wrong",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                              } else {
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
                                                        snapshot.data["data"][position]["out_time"]=="N/A"?
                                                        Container(
                                                          child: admins.contains(employee_role)?
                                                          widget.id!=snapshot.data["data"][position]["emp_id"].toString().trim()?Container(
                                                            child: InkWell(
                                                              onTap: () async {


                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context) => AlertDialog(
                                                                        content:
                                                                        // Generated code for this HomePage Widget...
                                                                        Container(
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                                                                    child: Icon(
                                                                                      Icons.calendar_today,
                                                                                      color: Colors.black,
                                                                                      size: 24,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    DateFormat("dd ,MMMM yyyy").format(DateTime.now()),
                                                                                    style: FlutterFlowTheme.of(context).bodyText1,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    const Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                                                                      child: FaIcon(
                                                                                        FontAwesomeIcons.clock,
                                                                                        color: Colors.black,
                                                                                        size: 24,
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: GestureDetector(
                                                                                        onTap: (){
                                                                                          _selectTime(context);
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                                border: Border.all(
                                                                                                  width: 1,
                                                                                                )),
                                                                                            width: 100,
                                                                                            child: TextFormField(
                                                                                              controller: textController1,
                                                                                              enabled: false,
                                                                                              obscureText: false,
                                                                                              decoration: InputDecoration(
                                                                                                hintStyle: FlutterFlowTheme.of(context).bodyText2,
                                                                                                enabledBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Color(0xFF504B4B),
                                                                                                    width: 1,
                                                                                                  ),
                                                                                                  borderRadius: BorderRadius.only(
                                                                                                    topLeft: Radius.circular(4.0),
                                                                                                    topRight: Radius.circular(4.0),
                                                                                                  ),
                                                                                                ),
                                                                                                focusedBorder: const OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Color(0xFF504B4B),
                                                                                                    width: 1,
                                                                                                  ),
                                                                                                  borderRadius: BorderRadius.only(
                                                                                                    topLeft: Radius.circular(4.0),
                                                                                                    topRight: Radius.circular(4.0),
                                                                                                  ),
                                                                                                ),
                                                                                                errorBorder: OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Color(0x00000000),
                                                                                                    width: 1,
                                                                                                  ),
                                                                                                  borderRadius: const BorderRadius.only(
                                                                                                    topLeft: Radius.circular(4.0),
                                                                                                    topRight: Radius.circular(4.0),
                                                                                                  ),
                                                                                                ),
                                                                                                focusedErrorBorder: OutlineInputBorder(
                                                                                                  borderSide: BorderSide(
                                                                                                    color: Color(0x00000000),
                                                                                                    width: 1,
                                                                                                  ),
                                                                                                  borderRadius: const BorderRadius.only(
                                                                                                    topLeft: Radius.circular(4.0),
                                                                                                    topRight: Radius.circular(4.0),
                                                                                                  ),
                                                                                                ),
                                                                                                filled: true,
                                                                                                fillColor: Color(0x00FFFFFF),
                                                                                                contentPadding:
                                                                                                EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                                                                                              ),
                                                                                              style:
                                                                                              FlutterFlowTheme.of(context).bodyText1.override(
                                                                                                fontFamily: 'Poppins',
                                                                                                lineHeight: 1,
                                                                                              ),
                                                                                              maxLines: 1,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                                                                      child: Icon(
                                                                                        Icons.text_snippet_outlined,
                                                                                        color: Colors.black,
                                                                                        size: 24,
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                                                                                        child: Container(
                                                                                          width: 100,
                                                                                          child: TextFormField(
                                                                                            controller: textController2,
                                                                                            autofocus: true,
                                                                                            obscureText: false,
                                                                                            decoration: InputDecoration(
                                                                                              hintStyle: FlutterFlowTheme.of(context).bodyText2,
                                                                                              enabledBorder: OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Color(0xFF504B4B),
                                                                                                  width: 1,
                                                                                                ),
                                                                                                borderRadius: const BorderRadius.only(
                                                                                                  topLeft: Radius.circular(4.0),
                                                                                                  topRight: Radius.circular(4.0),
                                                                                                ),
                                                                                              ),
                                                                                              focusedBorder: OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Color(0xFF504B4B),
                                                                                                  width: 1,
                                                                                                ),
                                                                                                borderRadius: const BorderRadius.only(
                                                                                                  topLeft: Radius.circular(4.0),
                                                                                                  topRight: Radius.circular(4.0),
                                                                                                ),
                                                                                              ),
                                                                                              errorBorder: OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Color(0x00000000),
                                                                                                  width: 1,
                                                                                                ),
                                                                                                borderRadius: const BorderRadius.only(
                                                                                                  topLeft: Radius.circular(4.0),
                                                                                                  topRight: Radius.circular(4.0),
                                                                                                ),
                                                                                              ),
                                                                                              focusedErrorBorder: OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Color(0x00000000),
                                                                                                  width: 1,
                                                                                                ),
                                                                                                borderRadius: const BorderRadius.only(
                                                                                                  topLeft: Radius.circular(4.0),
                                                                                                  topRight: Radius.circular(4.0),
                                                                                                ),
                                                                                              ),
                                                                                              filled: true,
                                                                                              fillColor: Color(0x00FFFFFF),
                                                                                              contentPadding:
                                                                                              EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                                                                                            ),
                                                                                            style:
                                                                                            FlutterFlowTheme.of(context).bodyText1.override(
                                                                                              fontFamily: 'Poppins',
                                                                                              lineHeight: 1,
                                                                                            ),
                                                                                            maxLines: 1,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),

                                                                              ElevatedButton(onPressed: () async {
                                                                                Navigator.pop(context);
                                                                                setState(() {
                                                                                  context.loaderOverlay.show();
                                                                                });
                                                                                Position locationposition = await _getGeoLocationPosition();

                                                                                List<Placemark> placemarks = await placemarkFromCoordinates(locationposition.latitude, locationposition.longitude);
                                                                                Placemark place = placemarks[0];
                                                                                address= '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                                                                                print(address);
                                                                                var df =  DateFormat("h:mma");
                                                                                String? h=textController1?.value.text;
                                                                                var da=h?.split(" ");
                                                                                var dt = df.parse(da!.first+""+da!.last);
                                                                                print(DateFormat('HH:mm').format(dt));
                                                                                Dio dio=Dio();
                                                                                var formData = FormData.fromMap({
                                                                                  'emp_id':snapshot.data["data"][position]["emp_id"].toString(),
                                                                                  "atte_date": "${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}",
                                                                                  "out_time":DateFormat('HH:mm').format(dt)+":00",
                                                                                  "admin_id":userId,
                                                                                  "remark":textController2?.value.text,
                                                                                  "out_longitude":locationposition.longitude,
                                                                                  "out_latitude":locationposition.latitude,
                                                                                  "out_location":address.toString()
                                                                                });
                                                                                print(formData.fields);
                                                                                var response = await dio.post('http://training.virash.in/outTimeByAdmin', data:formData);
                                                                                if (response.statusCode == 200) {
                                                                                  print(response.data);
                                                                                  if(response.data["success"]=="1") {

                                                                                      context.loaderOverlay.hide();

                                                                                  } else {
                                                                                      context.loaderOverlay.hide();
                                                                                    final snackBar = SnackBar(
                                                                                      content:  Text(response.data["message"]),
                                                                                      backgroundColor: (primaryColor),
                                                                                    );
                                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                                                  }
                                                                                } else {
                                                                                  print(response.statusCode);
                                                                                  final snackBar = SnackBar(
                                                                                    content: const Text('Please try again later'),
                                                                                    backgroundColor: (primaryColor),
                                                                                  );
                                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                  setState(() {
                                                                                    context.loaderOverlay.hide();
                                                                                  });

                                                                                }

                                                                              }, child: Text("MARK OUTTIME"))


                                                                            ],
                                                                          ),

                                                                        )

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
                      ),
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





