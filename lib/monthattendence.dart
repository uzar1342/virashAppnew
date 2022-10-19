import 'dart:collection';
import 'package:Virash/globals.dart';
import 'package:Virash/taskimg.dart';
import 'package:Virash/viewimage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:loader_overlay/loader_overlay.dart';
import 'OuttimeForm.dart';
import 'flutter_flow/flutter_flow_theme.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class MonthCalendarPage extends StatefulWidget {
  MonthCalendarPage({Key? key ,required this.name, required  this.id}) : super(key: key);
  String name;
  String id;
  @override
  _MonthCalendarPageState createState() => new _MonthCalendarPageState();
}
class _MonthCalendarPageState extends State<MonthCalendarPage> {
   int year=2022;
  var ocassion=[];
  bool monthloader=true;
   int day=1;
   int month=9;
   TextEditingController? textController1;
   TextEditingController? textController2;
   final scaffoldKey = GlobalKey<ScaffoldState>();

   @override
   void initState() {
     super.initState();
     textController1 = TextEditingController();
     textController1?.text = formatDate(
         DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute,DateTime.now().second),
         [h, ':', nn, " ", am]).toString();
     textController2 = TextEditingController();
     checkinternet();
     year=DateTime.now().year;
     day=DateTime.now().day;
     month=DateTime.now().month;
     FetchAttendence();
   }
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.red, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );
static Widget _presentIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.green, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );
static Widget _weekofIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );
static Widget _holidayIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.purple, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  bool net = true;
  var subscription;
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


  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2022, 9, 10): [
        Event(
          date: DateTime(2022, 9, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );
  bool isLoading = true;
  final Map<String, String> Holiyday = HashMap();
  final Map<String, String> Week = HashMap();
  final Map<String, String> Weekoff = HashMap();


  Future<dynamic> FetchAttendence()  async {
    setState(() {
      monthloader=false;
    });
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'emp_id':widget.id,
      "month":"${year}-${month>=10?month.toString():"0"+month.toString()}"
    });
    print(formData.fields);print(userId);
    var response = await dio.post('http://training.virash.in/attendance_details', data:formData);
    if (response.statusCode == 200) {
      if(response.data!=null)
        {
          int i, num=int.parse(response.data["data"].length.toString());
       for(i=0;i<num;i++)
         {
        if(response.data["data"][i]["attendance_date"]!=null)
  {

    if( response.data["data"][i]["Presentee"]=="Present")
      {
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(alignment:Alignment.bottomCenter,child: Text("●",style: TextStyle(color: Colors.lightGreen,fontSize: 20))),
              ),
              date: DateTime(year, month, day),
            ));
      }
    else if(response.data["data"][i]["Presentee"]=="Absent")
      {
        Week.addAll({response.data["data"][i]["attendance_date"]:"Absent"});
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Text("●",style: TextStyle(color: Colors.redAccent,fontSize: 20)), date: DateTime.now(),
            ));
      }else if(response.data["data"][i]["Presentee"]=="Went early")
      {
        Week.addAll({response.data["data"][i]["attendance_date"]:"Absent"});
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Text("●",style: TextStyle(color: Color(0xFFEFAA39),fontSize: 20)), date: DateTime.now(),
            ));
      }else if(response.data["data"][i]["Presentee"]=="Planned Leave")
      {
        Week.addAll({response.data["data"][i]["attendance_date"]:"Absent"});
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Text("●",style: TextStyle(color: Color(0xFFcf70a2),fontSize: 20)), date: DateTime.now(),
            ));
      }else if(response.data["data"][i]["Presentee"]=="Half Day")
      {
        Week.addAll({response.data["data"][i]["attendance_date"]:"Absent"});
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Text("●",style: TextStyle(color: Colors.yellow,fontSize: 20)), date: DateTime.now(),
            ));
      }else if(response.data["data"][i]["Presentee"]=="Full Day")
      {
        Week.addAll({response.data["data"][i]["attendance_date"]:"Absent"});
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Text("●",style: TextStyle(color: Colors.green,fontSize: 20)), date: DateTime.now(),
            ));
      }
    else if(response.data["data"][i]["Presentee"]=="Week off")
      {
        Weekoff.addAll({response.data["data"][i]["attendance_date"]:"Week off"});
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Text("●",style: TextStyle(color: Colors.blue,fontSize: 20)), date: DateTime.now(),
            ));
      }else if(response.data["data"][i]["Presentee"]=="Holiday")
      {
        Holiyday.addAll({response.data["data"][i]["attendance_date"]:response.data["data"][i]["occassion"]});
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        ocassion.add(day);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Text("●",style: TextStyle(color: Color(0xff5D10B9),fontSize: 20)), date: DateTime.now(),
            ));
      }else if(response.data["data"][i]["Presentee"]=="N/A")
      {
        String date=  response.data["data"][i]["attendance_date"];
        var d1=  date.split("-");
        int year=int.parse(d1[0]),month=int.parse(d1[1]),day=int.parse(d1[2]);
        ocassion.add(day);
        _markedDateMap.add(
            DateTime(year, month, day),
            Event(
              dot: Text("●",style: TextStyle(color: Colors.grey,fontSize: 20)), date: DateTime.now(),
            ));
      }

  }

         }

        }
      setState(() {
        monthloader = true;
      });
      print(response.data);
    } else {
      print(response.statusCode);
      final snackBar = SnackBar(
        content: const Text('Please try again later'),
        backgroundColor: (primaryColor),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        monthloader = true;
      });
    }
  }
  Future<dynamic> fetchEmployList()  async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'emp_id':widget.id,
      "attendance_date":"${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}"
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/dayStatusForEmployee', data:formData);
    if (response.statusCode == 200) {
      print(response.data);
      return response.data;
    } else {
      print(response.statusCode);
      final snackBar = SnackBar(
        content: const Text('Please try again later'),
        backgroundColor: (primaryColor),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return response.data;
    }
  }
var address;
  getLat()
  async {
    Position position = await _getGeoLocationPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address= '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
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
  void dispose() {
  subscription.cancel;
    super.dispose();
  }

  hideloader()
  {
    setState(() {
      context.loaderOverlay.hide();
    });
  }

  @override
  Widget build(BuildContext context) {


    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.black,
      onDayPressed: (date, events) {
        if(_targetDateTime.year==date.year&&_targetDateTime.month==date.month)
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => {day=date.day,year=date.year,month=date.month});
      },
      selectedDayButtonColor: Color(0xffc4cfa1),
      showOnlyCurrentMonthDate: false,
      childAspectRatio: 0.8,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      isScrollable: false,
      daysHaveCircularBorder: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 15,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return  Scaffold(
        key: _scaffoldKey,
        body: net?SafeArea(
          child: LoaderOverlay(
            child: Column(
              children: [
                admins.contains(employee_role)?
                Container(
                    padding: const EdgeInsets.only(top: 0.0),
                    height: h * 0.09,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ),
                      ],
                    )):
                Container(
                    padding: const EdgeInsets.only(top: 0.0),
                    height: h * 0.09,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Monthly Status",
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: w,
                          child: Column(
                            children: [
                              Container(
                                width: w,
                                height: 100,
                                padding: EdgeInsets.all(8),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: w*0.3,
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        child: Text('PREV'),
                                        onPressed: () {
                                          _markedDateMap.clear();
                                          print(_targetDateTime.month);  print(DateTime.now().month);
                                          setState(() {
                                            _targetDateTime = DateTime(
                                                _targetDateTime.year, _targetDateTime.month - 1);
                                            _currentMonth =
                                                DateFormat.yMMM().format(_targetDateTime);
                                            year=_targetDateTime.year;
                                            month=_targetDateTime.month;
                                            FetchAttendence();
                                            _currentDate2=_targetDateTime;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: w*0.3,
                                      alignment: Alignment.center,
                                      child: Text(
                                        _currentMonth,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                    ),
                                    _targetDateTime.month<DateTime.now().month?Container(
                                      width: w*0.3,
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        child: Text('NEXT'),
                                        onPressed: () {
                                          _markedDateMap.clear();
                                          print(_targetDateTime.month);
                                          setState(() {

                                            _targetDateTime = DateTime(
                                                _targetDateTime.year, _targetDateTime.month + 1);
                                            _currentMonth =
                                                DateFormat.yMMM().format(_targetDateTime);
                                            year=_targetDateTime.year;
                                            month=_targetDateTime.month;
                                            FetchAttendence();
                                            _currentDate2=_targetDateTime;
                                          });
                                        },
                                      ),
                                    ):Container(
                                      width: w*0.3,
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        child: Text('NEXT',style: TextStyle(color: Color(0xff656161)),),
                                        onPressed: () {
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: w,
                                height: h*0.5,
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                child: monthloader?_calendarCarouselNoHeader:Center(child: CircularProgressIndicator()),
                              ),
                              // Generated code for this Row Widget...
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Tooltip(
                                    verticalOffset: -60,
                                    message: "Full Day",
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'FD',
                                            style: FlutterFlowTheme.of(context).bodyText1,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    verticalOffset: -60,
                                    message: "Half Day",
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'HD',
                                            style: FlutterFlowTheme.of(context).bodyText1,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: Colors.yellow,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    verticalOffset: -60,
                                    message: "Went Early",
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'WE',
                                            style: FlutterFlowTheme.of(context).bodyText1,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEFAA39),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    verticalOffset: -60,
                                    message: "Absent",
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'AB',
                                            style: FlutterFlowTheme.of(context).bodyText1,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFDE3E54),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    verticalOffset: -60,
                                    message: "Week Off",
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'WO',
                                            style: FlutterFlowTheme.of(context).bodyText1,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF398DEF),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    verticalOffset: -60,
                                    message: "Holiday",
                                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'HO',
                                          style: FlutterFlowTheme.of(context).bodyText1,
                                        ),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF5D10B9),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Tooltip(
                                    verticalOffset: -60,
                                    message: "Planned Leave",
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'PL',
                                            style: FlutterFlowTheme.of(context).bodyText1,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFcf70a2),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              FutureBuilder<dynamic>(
                                future: fetchEmployList(), // async work
                                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
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
                                      }
                                      else {
                                        Color primaryColor = const Color(0xff1f7396);
                                        bool holiday=Holiyday.keys.contains("${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}");
                                        return !holiday?
                                        Container(
                                          child: snapshot.data["success"].toString().trim()=="1"?
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap:()=>{
                                                },
                                                child: Container(
                                                  child:
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

                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
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

                                                                        snapshot.data["data"][0]["in_time"],
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

                                                                        snapshot.data["data"][0]["out_time"].toString(),
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .black54)),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          const Divider(),
                                                          snapshot.data["data"][0]["remaining_hours"]!=null?Container(
                                                            child: snapshot.data["data"][0]["remaining_hours"]!="0"
                                                                ?Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text("Remaining hours: "),
                                                                    SizedBox(
                                                                      width: w * 0.01,
                                                                    ),
                                                                    Text(
                                                                        snapshot.data["data"][0]["remaining_hours"].toString(),
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .black54)),
                                                                  ],
                                                                )
                                                              ],
                                                            ):Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text("Extra Hours: "),
                                                                    SizedBox(
                                                                      width: w * 0.01,
                                                                    ),
                                                                    Text(
                                                                        snapshot.data["data"][0]["extra_hours"].toString(),
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .black54)),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ):Container(),
                                                          const Divider(),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text("Late : "),
                                                                  SizedBox(
                                                                    width: w * 0.01,
                                                                  ),
                                                                  Text(
                                                                      snapshot.data["data"][0]["late"].toString(),
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black54)),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          snapshot.data["data"][0]["extra_task"]!=null? Divider():Container(),
                                                          snapshot.data["data"][0]["extra_task"]!=null? Row(
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
                                                                    snapshot.data["data"][0]["extra_task"]!=null?snapshot.data["data"][0]["extra_task"].toString():"",
                                                                    maxLines: 20,style: const TextStyle(
                                                                    color: Colors
                                                                        .black54)),
                                                              ),
                                                            ],
                                                          ):Container(),
                                                          Divider(),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.end,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder:
                                                                                (context) =>
                                                                                viewimage(inimage: snapshot.data["data"][0]["in_image"].toString(), outimage: snapshot.data["data"][0]["out_image"].toString(),)));
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
                                                                    child:
                                                                    Row(children: const [
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
                                                              ),
                                                              snapshot.data["data"][0]["out_time"]==null?const SizedBox(width: 10,):Container(),
                                                              snapshot.data["data"][0]["out_time"]=="N/A"?  Container(
                                                                child: admins.contains(employee_role)?
                                                                widget.id!=userId?Container(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: InkWell(
                                                                      onTap: () {

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
                                                                                              DateFormat("dd ,MMMM yyyy").format(DateTime.parse("${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}")),
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
                                                                                         setState(() {
                                                                                           context.loaderOverlay.show();
                                                                                         });
                                                                                        Position position = await _getGeoLocationPosition();
                                                                                       var df =  DateFormat("h:mma");
                                                                                        String? h=textController1?.value.text;
                                                                                        var da=h?.split(" ");
                                                                                        var dt = df.parse(da!.first+""+da!.last);
                                                                                        print(DateFormat('HH:mm').format(dt));
                                                                                        Dio dio=Dio();
                                                                                        var formData = FormData.fromMap({
                                                                                          'emp_id':widget.id,
                                                                                          "atte_date": "${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}",
                                                                                          "out_time":DateFormat('HH:mm').format(dt)+":00",
                                                                                          "admin_id":userId,
                                                                                          "remark":textController2?.value.text,
                                                                                          "out_longitude":position.longitude,
                                                                                          "out_latitude":position.latitude,
                                                                                          "out_location":address.toString()
                                                                                        });
                                                                                        print(formData.fields);
                                                                                        var response = await dio.post('http://training.virash.in/outTimeByAdmin', data:formData);
                                                                                        if (response.statusCode == 200) {
                                                                                          print(response.data);
                                                                                          if(response.data["success"]=="1") {
                                                                                          hideloader();

                                                                                          } else {
                                                                                            hideloader();
                                                                                            final snackBar = SnackBar(
                                                                                              content:  Text(response.data["message"]),
                                                                                              backgroundColor: (primaryColor),
                                                                                            );
                                                                                            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);

                                                                                          }
                                                                                        } else {
                                                                                          hideloader();
                                                                                          print(response.statusCode);
                                                                                          final snackBar = SnackBar(
                                                                                            content: const Text('Please try again later'),
                                                                                            backgroundColor: (primaryColor),
                                                                                          );
                                                                                     ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);

                                                                                        }

                                                                                      }, child: Text("MARK OUTTIME"))


                                                                                    ],
                                                                                  ),

                                                                              )

                                                                            ));

                                                                        // Navigator.push(
                                                                        //     context,
                                                                        //     MaterialPageRoute(
                                                                        //         builder:
                                                                        //             (context) =>
                                                                                  //   DateTimePicker(id: widget.id, date: "${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}",)
                                                                        //     ));
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
                                                                  ),
                                                                ):Container():Container(),
                                                              ):Container(),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )



                                                  ,
                                                ),
                                              ),
                                              SizedBox(height: 50,),
                                              Text("TASK LIST",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                              snapshot.data["data"][0]["task"]!=null?
                                              Container(
                                                width: w,
                                                child:  snapshot.data["data"][0]["task"].length>0?ListView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: snapshot.data["data"][0]["task"].length,
                                                    itemBuilder: (BuildContext context, int index){
                                                      return
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 4),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.blueGrey.withOpacity(0.1),
                                                                  spreadRadius: 3,
                                                                  blurRadius:2,
                                                                  offset: Offset(0, 7), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Card(
                                                              elevation: 3,
                                                              surfaceTintColor: Colors.red,
                                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius.circular(10),
                                                                bottomRight: Radius.circular(10),
                                                                topLeft: Radius.circular(10),
                                                                topRight: Radius.circular(10),
                                                              )),
                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Row(
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.max,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                                                                      child:
                                                                                      GestureDetector(
                                                                                        onTap: (){
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) => AlertDialog(
                                                                                                content:
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
                                                                                                      width: w*0.5,
                                                                                                      child: Text(
                                                                                                          snapshot.data["data"][0]["task"]!=null?snapshot.data["data"][0]["task"].toString():"",
                                                                                                          maxLines: 8,
                                                                                                          style: const TextStyle(
                                                                                                              color: Colors
                                                                                                                  .black54)),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ));
                                                                                        },
                                                                                        child: RichText(
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          strutStyle: StrutStyle(fontSize: 17.0),
                                                                                          text: TextSpan(
                                                                                              style:  FlutterFlowTheme.of(context).bodyText1,
                                                                                              text: snapshot.data["data"][0]["task"][index]["title"].toString()),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  snapshot.data["data"][0]["task_img"]!="N/A"&&snapshot.data["data"][0]["task_img"]!=null?Expanded(
                                                                                    flex: 1,
                                                                                    child: GestureDetector(
                                                                                      onTap: (){
                                                                                        Navigator.push(context, MaterialPageRoute(builder: (c)=>Taskimg(img:  snapshot.data["data"][0]["task_img"],)));
                                                                                      },
                                                                                      child: Container(
                                                                                        width: 30,
                                                                                        height: 30,
                                                                                        decoration: const BoxDecoration(
                                                                                          color: Color(0x00FFFFFF),
                                                                                          shape: BoxShape.rectangle,
                                                                                        ),
                                                                                        child: const Icon(
                                                                                          Icons.image_sharp,
                                                                                          color: Colors.black,
                                                                                          size: 24,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ):
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Container(
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
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                                                                      child: Text(
                                                                                        snapshot.data["data"][0]["task"][index]["task_date"].toString()+"@"+snapshot.data["data"][0]["task"][index]["assigned_time"].toString(),
                                                                                        style: FlutterFlowTheme.of(context).bodyText2.override(
                                                                                          fontFamily: 'Poppins',
                                                                                          color: Color(0xFF888C91),
                                                                                          fontWeight: FontWeight.normal,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Padding(
                                                                                      padding:
                                                                                      EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                                                                                      child: Container(
                                                                                        width: 30,
                                                                                        height: 30,
                                                                                        decoration:  BoxDecoration(
                                                                                          color: snapshot.data["data"][0]["task"][index]["priority"]=="High"?
                                                                                          Colors
                                                                                              .red:snapshot.data["data"][0]["task"][index]["priority"]=="Medium"?snapshot.data["data"][0]["task"][index]["priority"]=="N/A"?Colors
                                                                                              .grey:Colors
                                                                                              .blue:Colors
                                                                                              .green,
                                                                                          borderRadius: const BorderRadius.only(
                                                                                            bottomLeft: Radius.circular(0),
                                                                                            bottomRight: Radius.circular(10),
                                                                                            topLeft: Radius.circular(10),
                                                                                            topRight: Radius.circular(0),
                                                                                          ),
                                                                                        ),
                                                                                        child: Align(
                                                                                          alignment: AlignmentDirectional(0, 0),
                                                                                          child: Text(
                                                                                            snapshot.data["data"][0]["task"][index]["priority"],
                                                                                            textAlign: TextAlign.center,
                                                                                            style: FlutterFlowTheme.of(context)
                                                                                                .subtitle1
                                                                                                .override(
                                                                                              fontFamily: 'Poppins',
                                                                                              color: FlutterFlowTheme.of(context)
                                                                                                  .primaryBtnText,
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
                                                                  ),
                                                                   Padding(
                                                                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                                    child: Row(
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: snapshot.data["data"][0]["task"][index]["task_status"]=="Completed"?
                                                                              Color(0xFF91b7ed):snapshot.data["data"][0]["task"][index]["task_status"]=="Pending"?Color(0xFFedc791):
                                                                              snapshot.data["data"][0]["task"][index]["task_status"]=="Rejected"?Color(0xFFed9c91):
                                                                              snapshot.data["data"][0]["task"][index]["task_status"]=="Approved"?Colors.green:Colors.grey,
                                                                            ),
                                                                            alignment: AlignmentDirectional(0, 0),
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: Text(
                                                                                      snapshot.data["data"][0]["task"][index]["task_status"],
                                                                                      textAlign: TextAlign.center,
                                                                                      style: FlutterFlowTheme.of(context).bodyText1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                snapshot.data["data"][0]["task"][index]["task_status"]!="Completed"?
                                                                                snapshot.data["data"][0]["task"][index]["rejected_remark"]!="N/A"&&snapshot.data["data"][0]["task"][index]["rejected_remark"]!=null?
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: GestureDetector(
                                                                                    onTap: ()
                                                                                    {
                                                                                      print(snapshot.data["data"][0]["task"][index]["task_id"].toString());
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            content:
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
                                                                                                  width: w*0.5,
                                                                                                  child: Text(
                                                                                                      snapshot.data["data"][0]["task"][index]["rejected_remark"]!=null?snapshot.data["data"][0]["task"][index]["rejected_remark"].toString():"",
                                                                                                      maxLines: 8,
                                                                                                      style: const TextStyle(
                                                                                                          color: Colors
                                                                                                              .black54)),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ));
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 30,
                                                                                      height: 30,
                                                                                      decoration:  BoxDecoration(
                                                                                        color: primaryColor,
                                                                                        borderRadius: BorderRadius.only(
                                                                                          bottomLeft: Radius.circular(0),
                                                                                          bottomRight: Radius.circular(10),
                                                                                          topLeft: Radius.circular(10),
                                                                                          topRight: Radius.circular(0),
                                                                                        ),
                                                                                      ),
                                                                                      child: Align(
                                                                                        alignment: AlignmentDirectional(0, 0),
                                                                                        child: Text(
                                                                                          "Remark",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: FlutterFlowTheme.of(context)
                                                                                              .subtitle1
                                                                                              .override(
                                                                                            fontFamily: 'Poppins',
                                                                                            color: FlutterFlowTheme.of(context)
                                                                                                .primaryBtnText,
                                                                                            fontSize: 12,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ):Container():Expanded(
                                                                                  flex: 1,
                                                                                  child: GestureDetector(
                                                                                    onTap: ()
                                                                                    {
                                                                                      print(snapshot.data["data"][0]["task"][index]["task_id"].toString());
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => AlertDialog(
                                                                                            content:
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
                                                                                                  width: w*0.5,
                                                                                                  child: Text(
                                                                                                      snapshot.data["data"][0]["task"][index]["completed_remark"]!=null?snapshot.data["data"][0]["task"][index]["completed_remark"].toString():"",
                                                                                                      maxLines: 8,
                                                                                                      style: const TextStyle(
                                                                                                          color: Colors
                                                                                                              .black54)),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ));
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 30,
                                                                                      height: 30,
                                                                                      decoration:  BoxDecoration(
                                                                                        color: primaryColor,
                                                                                        borderRadius: const BorderRadius.only(
                                                                                          bottomLeft: Radius.circular(0),
                                                                                          bottomRight: Radius.circular(10),
                                                                                          topLeft: Radius.circular(10),
                                                                                          topRight: Radius.circular(0),
                                                                                        ),
                                                                                      ),
                                                                                      child: Align(
                                                                                        alignment: AlignmentDirectional(0, 0),
                                                                                        child: Text(
                                                                                          "Remark",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: FlutterFlowTheme.of(context)
                                                                                              .subtitle1
                                                                                              .override(
                                                                                            fontFamily: 'Poppins',
                                                                                            color: FlutterFlowTheme.of(context)
                                                                                                .primaryBtnText,
                                                                                            fontSize: 12,
                                                                                          ),
                                                                                        ),
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

                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      //   Card(
                                                      //     elevation: 4,child: Column(
                                                      //   children: [
                                                      //     Padding(
                                                      //       padding: const EdgeInsets.all(8.0),
                                                      //       child: Row(
                                                      //         mainAxisAlignment:
                                                      //         MainAxisAlignment
                                                      //             .spaceBetween,
                                                      //         children: [
                                                      //           Row(
                                                      //             children: [
                                                      //
                                                      //               SizedBox(
                                                      //                 width: w * 0.02,
                                                      //               ),
                                                      //               Text(
                                                      //                 "Priority : "+snapshot.data["data"][0]["task"][0]["priority"].toString(),
                                                      //                 style: const TextStyle(
                                                      //                     color: Colors
                                                      //                         .black54,
                                                      //                     fontWeight:
                                                      //                     FontWeight
                                                      //                         .bold,
                                                      //                     fontSize: 17.0),
                                                      //               )
                                                      //             ],
                                                      //           ),
                                                      //
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //     const Divider(),
                                                      //     Padding(
                                                      //       padding: const EdgeInsets.all(8.0),
                                                      //       child: Row(
                                                      //         mainAxisAlignment:
                                                      //         MainAxisAlignment
                                                      //             .spaceBetween,
                                                      //         children: [
                                                      //           Row(
                                                      //             crossAxisAlignment:
                                                      //             CrossAxisAlignment
                                                      //                 .center,
                                                      //             mainAxisAlignment:
                                                      //             MainAxisAlignment
                                                      //                 .start,
                                                      //             children: [
                                                      //
                                                      //               SizedBox(
                                                      //                 width: w * 0.02,
                                                      //               ),
                                                      //               Container(
                                                      //                 width: w*0.8,
                                                      //                 child: Text(
                                                      //                   "TASK : "+snapshot.data["data"][0]["task"][0]["title"].toString(),
                                                      //                   softWrap: true,maxLines:8,style: const TextStyle(
                                                      //                   color: Colors
                                                      //                       .black54,
                                                      //                   fontWeight:
                                                      //                   FontWeight
                                                      //                       .bold,
                                                      //                 ),
                                                      //                 ),
                                                      //               )
                                                      //             ],
                                                      //           ),
                                                      //
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //
                                                      //     Padding(
                                                      //       padding: const EdgeInsets.all(8.0),
                                                      //       child: Container(
                                                      //         width: w,
                                                      //         color: snapshot.data["data"][0]["task"][0]["task_status"]=="Completed"?
                                                      //         Color(0xFF91b7ed):snapshot.data["data"][0]["task"][0]["task_status"]=="Pending"?Color(0xFFedc791):
                                                      //         snapshot.data["data"][0]["task"][0]["task_status"]=="Rejected"?Color(0xFFed9c91):Color(0xff91edbf),
                                                      //         child: Padding(
                                                      //           padding: const EdgeInsets.all(8.0),
                                                      //           child: Row(
                                                      //             mainAxisAlignment:
                                                      //             MainAxisAlignment
                                                      //                 .spaceBetween,
                                                      //             children: [
                                                      //               Row(
                                                      //                 crossAxisAlignment:
                                                      //                 CrossAxisAlignment
                                                      //                     .center,
                                                      //                 mainAxisAlignment:
                                                      //                 MainAxisAlignment
                                                      //                     .start,
                                                      //                 children: [
                                                      //
                                                      //                   if(snapshot.data["data"][0]["task"][0]["task_status"]=="Completed")
                                                      //                     Text(
                                                      //                       "Status : "+snapshot.data["data"][0]["task"][0]["task_status"].toString(),
                                                      //                       style: const TextStyle(
                                                      //                           color: Color(0xff0e1163),
                                                      //                           fontWeight:
                                                      //                           FontWeight
                                                      //                               .bold,
                                                      //                           fontSize: 17.0),
                                                      //                     )else if(snapshot.data["data"][0]["task"][0]["task_status"]=="Pending")
                                                      //                     Text(
                                                      //                       "Status : "+snapshot.data["data"][0]["task"][index]["task_status"].toString(),
                                                      //                       style: const TextStyle(
                                                      //                           color: Color(
                                                      //                               0xff63400e),
                                                      //                           fontWeight:
                                                      //                           FontWeight
                                                      //                               .bold,
                                                      //                           fontSize: 17.0),
                                                      //                     )else if(snapshot.data["data"][0]["task"][index]["task_status"]=="Rejected")
                                                      //                       Text(
                                                      //                         "Status : "+snapshot.data["data"][0]["task"][index]["task_status"].toString(),
                                                      //                         style: const TextStyle(
                                                      //                             color: Color(0xff63190e),
                                                      //                             fontWeight:
                                                      //                             FontWeight
                                                      //                                 .bold,
                                                      //                             fontSize: 17.0),
                                                      //                       )else if(snapshot.data["data"][0]["task"][index]["task_status"]=="Approved")
                                                      //                         Text(
                                                      //                           "Status : "+snapshot.data["data"][0]["task"][index]["task_status"].toString(),
                                                      //                           style: const TextStyle(
                                                      //                               color: Color(0xff0e6339),
                                                      //                               fontWeight:
                                                      //                               FontWeight
                                                      //                                   .bold,
                                                      //                               fontSize: 17.0),
                                                      //                         ),
                                                      //                   SizedBox(width: 2,)
                                                      //                 ],
                                                      //               ),
                                                      //
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ));

                                                    }):Image.asset("assets/no_data.png"),
                                              ): Image.asset("assets/no_data.png"),
                                            ],
                                          ):
                                          Week.keys.contains("${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}")?
                                          Card(
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
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                      },
                                                      child: Container(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(5.0),
                                                        height: h * 0.04,
                                                        decoration:  const BoxDecoration(
                                                            color:  Colors.red,
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

                                                          ],
                                                        ),
                                                      ),
                                                    )

                                                  ],
                                                ),

                                              ],
                                            ),
                                          ):


                                          Weekoff.keys.contains("${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}")?

                                          Card(
                                            elevation: 3.0,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14.0))),
                                            child:            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [


                                              ],
                                            ),
                                          ):
                                          Card(
                                            elevation: 3.0,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14.0))),
                                            child:            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [


                                              ],
                                            ),
                                          ),
                                        ):
                                        Center(child: Card(
                                          elevation: 3.0,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(14.0))),
                                          child:            Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                              Holiyday["${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}"]!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),


                                        ),);
                                      }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                    const SizedBox(height: 100,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ):SafeArea(
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
            )));
  }
}