import 'package:Virash/virash_app_home_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as d;
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import 'dash_page.dart';
import 'globals.dart';

class DateTimePicker extends StatefulWidget {
   DateTimePicker({Key? key,required this.id,required this.date}) : super(key: key);
  String id,date;
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late double _height;
  late double _width;

  String _setTime="", setDate="",address="";

  late String _hour, _minute, _time;
  late Position position;
  late String dateTime;
  bool isLoading=true;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _remark = TextEditingController();


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



  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [h, ':', nn, " ", am]).toString();
      });
  }
getLat()
async {
  Position position = await _getGeoLocationPosition();
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  print(placemarks);
  Placemark place = placemarks[0];
  address= '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
}
  @override
  void initState() {
    getLat();
    _dateController.text = widget.date;
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute,DateTime.now().second),
        [h, ':', nn, " ", am]).toString();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Date time picker'),
      ),
      body: isLoading?Container(
        width: _width,
        height: _height,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                  },
                  child: Container(
                    width: _width * 0.8,
                    height: _height *0.1,
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      decoration: InputDecoration(
                          disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: _width * 0.8,
                    height: _height *0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      onSaved: (val) {
                        _setTime = val!;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                          disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.all(5)),
                    ),
                  ),
                ),


              ],
            ),

            Container(
              margin: EdgeInsets.only(top: 30),
              width: _width *0.8,
              height: _height * 0.1,
              alignment: Alignment.center,
              child: TextFormField(
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                controller: _remark,
                decoration: InputDecoration(
    border: OutlineInputBorder()
    ),
              ),
            ),

            ElevatedButton(onPressed: () async {
              setState(() {
                isLoading = false;
              });
              Position position = await _getGeoLocationPosition();

              var df =  DateFormat("h:mma");
              String h=_timeController.value.text;
              var da=h.split(" ");
              var dt = df.parse(da.first+""+da.last);
              print(DateFormat('HH:mm').format(dt));

              Dio dio=Dio();
              var formData = FormData.fromMap({
                'emp_id':widget.id,
                "atte_date": _dateController.value.text,
                "out_time":DateFormat('HH:mm').format(dt)+":00",
                "admin_id":userId,
                "remark":_remark.value.text,
                "out_longitude":position.longitude,
                "out_latitude":position.latitude,
                "out_location":address.toString()
              });
              print(formData.fields);
              var response = await dio.post('http://training.virash.in/outTimeByAdmin', data:formData);
              if (response.statusCode == 200) {
                print(response.data);
                Get.off(()=>(DashPage()));
              } else {
                print(response.statusCode);
                Fluttertoast.showToast(msg: "Please try again later");
                setState(() {
                  isLoading = true;
                });

              }


            }, child: Text("Send"))
          ],
        ),
      ):Center(child: CircularProgressIndicator()),
    );
  }
}