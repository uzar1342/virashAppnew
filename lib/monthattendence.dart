import 'dart:collection';
import 'package:Virash/globals.dart';
import 'package:Virash/viewimage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'OuttimeForm.dart';


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


  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2022, 9, 10): [
        new Event(
          date: new DateTime(2022, 9, 10),
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
                child: Container(alignment:Alignment.bottomCenter,child: Text("●",style: TextStyle(color: Colors.green,fontSize: 20))),
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
      Fluttertoast.showToast(msg: "Please try again later");
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
      Fluttertoast.showToast(msg: "Please try again later");
      return response.data;
    }
  }

  @override
  void initState() {
    checkinternet();
    year=DateTime.now().year;
    day=DateTime.now().day;
    month=DateTime.now().month;
    /// Add more events to _markedDateMap EventList
    FetchAttendence();
    super.initState();
  }
@override
  void dispose() {
  subscription.cancel;
    super.dispose();
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
        this.setState(() {
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
        body: net?SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: w,
                  child: Column(
                    children: [
                      employee_role=="Admin"||employee_role=="Super Admin"||employee_role=="Faculty & Admin"?Container(
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
                                "Monthly Status",
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
                          )):Container(
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
                                style: TextStyle(
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
                        height: h*0.6,
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        child: monthloader?_calendarCarouselNoHeader:Center(child: CircularProgressIndicator()),
                      ), //
                      FutureBuilder<dynamic>(
                        future: fetchEmployList(), // async work
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError)
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
                              else {
                                Color primaryColor = const Color(0xff1f7396);
                                bool holiday=Holiyday.keys.contains("${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}");
                                print(Week);
                                return !holiday?Container(
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
                                                            widget.name,
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
                                                        },
                                                        child: Container(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(5.0),
                                                          height: h * 0.04,
                                                          decoration:  BoxDecoration(
                                                              color:  snapshot.data["data"][0]["attendance_status"]=="Full Day"?Colors
                                                                  .green:snapshot.data["data"][0]["attendance_status"]=="Half Day"?Colors
                                                                  .orange:Colors.red,
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
                                                                snapshot.data["data"][0]["attendance_status"].toString(),
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
                                                            snapshot.data["data"][0]["extra_task"]!=null?snapshot.data["data"][0]["extra_task"].toString():"",
                                                            maxLines: 20,style: const TextStyle(
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
                                                      snapshot.data["data"][0]["out_time"]==null?SizedBox(width: 10,):Container(),
                                                      snapshot.data["data"][0]["out_time"]=="N/A"?  Container(
                                                        child: employee_role=="Admin"||employee_role=="Super Admin"||employee_role=="Faculty & Admin"?
                                                        widget.id!=userId?Container(
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
                                              return Card(elevation: 4,child: Column(
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

                                                            SizedBox(
                                                              width: w * 0.02,
                                                            ),
                                                            Text(
                                                              "Priority : "+snapshot.data["data"][0]["task"][index]["priority"].toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 17.0),
                                                            )
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
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
                                                            Container(
                                                              width: w*0.8,
                                                              child: Text(
                                                                "TASK : "+snapshot.data["data"][0]["task"][index]["title"].toString(),
                                                                softWrap: true,maxLines:8,style: const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                              ),
                                                              ),
                                                            )
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      width: w,
                                                      color: snapshot.data["data"][0]["task"][index]["task_status"]=="Completed"?
                                                      Color(0xFF91b7ed):snapshot.data["data"][0]["task"][index]["task_status"]=="Pending"?Color(0xFFedc791):
                                                      snapshot.data["data"][0]["task"][index]["task_status"]=="Rejected"?Color(0xFFed9c91):Color(0xff91edbf),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
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

                                                                if(snapshot.data["data"][0]["task"][index]["task_status"]=="Completed")
                                                                  Text(
                                                                    "Status : "+snapshot.data["data"][0]["task"][index]["task_status"].toString(),
                                                                    style: const TextStyle(
                                                                        color: Color(0xff0e1163),
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        fontSize: 17.0),
                                                                  )else if(snapshot.data["data"][0]["task"][index]["task_status"]=="Pending")
                                                                  Text(
                                                                    "Status : "+snapshot.data["data"][0]["task"][index]["task_status"].toString(),
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xff63400e),
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        fontSize: 17.0),
                                                                  )else if(snapshot.data["data"][0]["task"][index]["task_status"]=="Rejected")
                                                                    Text(
                                                                      "Status : "+snapshot.data["data"][0]["task"][index]["task_status"].toString(),
                                                                      style: const TextStyle(
                                                                          color: Color(0xff63190e),
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                          fontSize: 17.0),
                                                                    )else if(snapshot.data["data"][0]["task"][index]["task_status"]=="Approved")
                                                                      Text(
                                                                        "Status : "+snapshot.data["data"][0]["task"][index]["task_status"].toString(),
                                                                        style: const TextStyle(
                                                                            color: Color(0xff0e6339),
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                            fontSize: 17.0),
                                                                      ),
                                                                SizedBox(width: 2,)
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ));

                                            }):Image.asset("assets/no_data.png"),
                                      ): Image.asset("assets/no_data.png"),
                                    ],
                                  ):Week.keys.contains("${year}-${month>=10?month.toString():"0"+month.toString()}-${day>=10?day.toString():"0"+day.toString()}")?
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
                                                Text(
                                                  widget.name,
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
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets
                                                    .all(5.0),
                                                height: h * 0.04,
                                                decoration:  BoxDecoration(
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
                                                    Text(
                                                      "Absent",
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
                                                  widget.name,
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
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets
                                                    .all(5.0),
                                                height: h * 0.04,
                                                decoration:  BoxDecoration(
                                                    color:  Color(0xff05b0ff),
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
                                                      "Week Off",
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

                                      ],
                                    ),
                                  ):Card(
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
                                                  widget.name,
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
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets
                                                    .all(5.0),
                                                height: h * 0.04,
                                                decoration:  BoxDecoration(
                                                    color:  Colors.grey,
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
                                                      "N/A",
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

                                      ],
                                    ),
                                  ),
                                ):Center(child: Card(
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
                                                widget.name,
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
                                            },
                                            child: Container(
                                              padding:
                                              const EdgeInsets
                                                  .all(5.0),
                                              height: h * 0.04,
                                              decoration:  BoxDecoration(
                                                  color:  Colors.purple,
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
                                                    "Holiday",
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

            SizedBox(height: 100,)
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