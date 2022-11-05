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

final TextEditingController _searchController = TextEditingController();
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
    viewattendence();
    checkinternet();
    final selectedDayFormattedDate = formatter.format(selectedDay);
    _selectedEvents = ValueNotifier(
        _getEventsForDay(formatter.parse(selectedDayFormattedDate)));
    super.initState();
  }

  var data;
  bool isLoading=true;
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
      data= response.data;
      setState(() {
        isLoading=false;
      });
    }
    else
    {
      print(response.statusCode);
      data= response.data ;
      setState(() {
        isLoading=false;
      });
    }

  }


  @override
  void dispose() {
    _searchController.clear();
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


  refress()
  {
    setState(() {

    });
  }

  hideloader()
  {
    setState(() {
      context.loaderOverlay.hide();
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xff1f7396);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return LoaderOverlay(
      child: Scaffold(
        key: _scaffoldKey,
        body: net?SafeArea(
            child:!isLoading? Column(
              children: [
              Expanded(
              flex: 1,
              child: taskbar(refress),
            ),
                //SizedBox(height: h * 0.02),
                Expanded(
                  flex: 8,
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: () async {
                      _refreshIndicatorKey.currentState?.show();
                      viewattendence();
                      setState(() {
                      });
                      return Future<void>.delayed(const Duration(seconds: 3));
                    },
                    child: Container(
                      child: data["data"].length>0?ListView.builder(
                        itemCount: data["data"].length,
                        itemBuilder: (context, position) {
                          if (data["data"][position]['emp_name']
                              .toString()
                              .toLowerCase()
                              .contains(
                              _searchController.text.toLowerCase())||data["data"][position]['Presentee']
                              .toString()
                              .toLowerCase()
                              .contains(
                              _searchController.text.toLowerCase())) {
                            return Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey
                                        .withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 2,
                                    offset: Offset(0,
                                        7), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.all(4.0),
                                child: Card(
                                  elevation: 3,
                                  surfaceTintColor: Colors.red,
                                  shape:
                                  const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.only(
                                        bottomLeft:
                                        Radius.circular(10),
                                        bottomRight:
                                        Radius.circular(10),
                                        topLeft:
                                        Radius.circular(10),
                                        topRight:
                                        Radius.circular(10),
                                      )),
                                  clipBehavior: Clip
                                      .antiAliasWithSaveLayer,
                                  child: Column(
                                    mainAxisSize:
                                    MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize:
                                        MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .all(8.0),
                                            child: Container(
                                                width: 50,
                                                height: 50,
                                                clipBehavior: Clip
                                                    .antiAlias,
                                                decoration:
                                                BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,
                                                ),
                                                child: Image
                                                    .network(
                                                  data[
                                                  "data"]
                                                  [
                                                  position]
                                                  [
                                                  "profile_img"].toString(),
                                                  loadingBuilder: (BuildContext
                                                  context,
                                                      Widget
                                                      child,
                                                      ImageChunkEvent?
                                                      loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child:
                                                      CircularProgressIndicator(
                                                        value: loadingProgress.expectedTotalBytes !=
                                                            null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                            loadingProgress.expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                )),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize:
                                              MainAxisSize
                                                  .max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                  MainAxisSize
                                                      .max,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child:
                                                      GestureDetector(
                                                        onTap:
                                                            () {

                                                        },
                                                        child:
                                                        RichText(
                                                          maxLines:
                                                          1,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          strutStyle:
                                                          StrutStyle(fontSize: 17.0),
                                                          text: TextSpan(
                                                              style: FlutterFlowTheme.of(context).bodyText1,
                                                              text: data["data"][position]["emp_name"]),
                                                        ),
                                                      ),
                                                    ),
                                                    data["data"][position]["in_time"] !=
                                                        "N/A"
                                                        ? Expanded(
                                                      flex:
                                                      1,
                                                      child:
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                      viewimage(inimage: data["data"][position]["in_image"].toString(), outimage: data["data"][position]["out_image"].toString(),)));
                                                        },
                                                        child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            color: Color(0x00FFFFFF),
                                                            shape: BoxShape.rectangle,
                                                          ),
                                                          child: Icon(
                                                            Icons.image_sharp,
                                                            color: Colors.black,
                                                            size: 24,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                        : Expanded(
                                                      flex:
                                                      1,
                                                      child:
                                                      Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: const BoxDecoration(
                                                          color: Color(0x00FFFFFF),
                                                          shape: BoxShape.rectangle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.image_not_supported_outlined,
                                                          color: Color(0xFF898585),
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                  MainAxisSize
                                                      .max,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child:
                                                      Padding(
                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                            10,
                                                            0,
                                                            0,
                                                            0),
                                                        child:
                                                        Text(
                                                          data["data"][position]["in_time"] +
                                                              " TO " +
                                                              data["data"][position]["out_time"],
                                                          style: FlutterFlowTheme.of(context)
                                                              .bodyText2
                                                              .override(
                                                            fontFamily: 'Poppins',
                                                            color: Color(0xFF888C91),
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child:
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                            10,
                                                            0,
                                                            10,
                                                            10),
                                                        child:
                                                        Container(
                                                          width:
                                                          30,
                                                          height:
                                                          30,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: data["data"][position]["Presentee"] == "Absent"
                                                                ? Colors.red
                                                                : data["data"][position]["Presentee"] == "Present"
                                                                ? Colors.green
                                                                : Colors.grey,
                                                            borderRadius:
                                                            const BorderRadius.only(
                                                              bottomLeft: Radius.circular(0),
                                                              bottomRight: Radius.circular(10),
                                                              topLeft: Radius.circular(10),
                                                              topRight: Radius.circular(0),
                                                            ),
                                                          ),
                                                          child:
                                                          Align(
                                                            alignment:
                                                            AlignmentDirectional(0, 0),
                                                            child:
                                                            Text(
                                                              data["data"][position]["Presentee"],
                                                              textAlign: TextAlign.center,
                                                              style: FlutterFlowTheme.of(context).subtitle1.override(
                                                                fontFamily: 'Poppins',
                                                                color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .fromLTRB(
                                            0, 8, 0, 0),
                                        child: Row(
                                          mainAxisSize:
                                          MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration:
                                                BoxDecoration(
                                                  color: data["data"][position]
                                                  [
                                                  "out_time"] ==
                                                      "N/A"
                                                      && data["data"][position]
                                                      [
                                                      "in_time"] !=
                                                          "N/A"? primaryColor
                                                      : Color(0xff79b0c7),
                                                ),
                                                alignment:
                                                AlignmentDirectional(
                                                    0, 0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                      GestureDetector(
                                                        onTap: (){
                                                          if(data["data"][position]
                                                          [
                                                          "out_time"] ==
                                                              "N/A"
                                                              && data["data"][position]
                                                              [
                                                              "in_time"] !=
                                                                  "N/A") {
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
                                                                              const Padding(
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
                                                                                            errorBorder: const OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: Color(0x00000000),
                                                                                                width: 1,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.only(
                                                                                                topLeft: Radius.circular(4.0),
                                                                                                topRight: Radius.circular(4.0),
                                                                                              ),
                                                                                            ),
                                                                                            focusedErrorBorder: const OutlineInputBorder(
                                                                                              borderSide: BorderSide(
                                                                                                color: Color(0x00000000),
                                                                                                width: 1,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.only(
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
                                                                                const Padding(
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
                                                                                          errorBorder: const OutlineInputBorder(
                                                                                            borderSide: BorderSide(
                                                                                              color: Color(0x00000000),
                                                                                              width: 1,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.only(
                                                                                              topLeft: Radius.circular(4.0),
                                                                                              topRight: Radius.circular(4.0),
                                                                                            ),
                                                                                          ),
                                                                                          focusedErrorBorder: const OutlineInputBorder(
                                                                                            borderSide: BorderSide(
                                                                                              color: Color(0x00000000),
                                                                                              width: 1,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.only(
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

                                                                            Position locationposition = await _getGeoLocationPosition();
                                                                            setState(() {
                                                                              context.loaderOverlay.show();
                                                                            });
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
                                                                              'emp_id':data["data"][position]["emp_id"].toString(),
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
                                                                                viewattendence();
                                                                                hideloader();
                                                                                final snackBar = SnackBar(
                                                                                  content:  Text(response.data["message"]),
                                                                                  backgroundColor: (primaryColor),
                                                                                );
                                                                                ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);


                                                                              } else {
                                                                                hideloader();
                                                                                final snackBar = SnackBar(
                                                                                  content:  Text(response.data["message"]),
                                                                                  backgroundColor: (Colors.red),
                                                                                );
                                                                                ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);

                                                                              }
                                                                            } else {
                                                                              hideloader();
                                                                              print(response.statusCode);
                                                                              final snackBar = SnackBar(
                                                                                content: const Text('Please try again later'),
                                                                                backgroundColor: (Colors.red),
                                                                              );
                                                                              ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);


                                                                            }

                                                                          }, child: Text("MARK OUTTIME"))


                                                                        ],
                                                                      ),

                                                                    )

                                                                ));
                                                          }




                                                        },
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(5.0),
                                                          child:
                                                          Text(
                                                            "Mark outtime",
                                                            textAlign:
                                                            TextAlign.center,
                                                            style:
                                                            FlutterFlowTheme.of(context).bodyText1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          else
                            return  Container();
                        },
                      ):Container(child: Center(child: Image.asset("assets/no_data.png")),),
                    ),
                  ),
                ),
              ],
            ):Center(child: CircularProgressIndicator(color:Colors.lightBlue))):
        SafeArea(
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
      ),
    );
  }
  
}
class taskbar extends StatefulWidget {
   taskbar(Function() this.refress, {Key? key}) : super(key: key);
   var refress;
  @override
  State<taskbar> createState() => _taskbarState();
}

class _taskbarState extends State<taskbar> {
  bool showSearch = true;
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xff1f7396);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return  showSearch ?Container(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Today's Attendence",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          showSearch = !showSearch;
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: primaryColor,
                      )),
                ],
              ),
            )
          ],
        )):
    Row(
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
              autofocus: true,
              controller: _searchController,
              onChanged: (value) {
                widget.refress();
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
                      widget.refress();
                      _searchController.clear();
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
                _searchController.clear();
                showSearch = !showSearch;
              });
            },
            child: Text("Close",
                style: TextStyle(
                  color: Colors.black54,
                  decoration: TextDecoration.underline,
                ))),
      ],
    );
  }
}






