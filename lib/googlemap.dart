import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class Googlem extends StatefulWidget {
  Googlem({Key? key,required this.lan,required this.lug}) : super(key: key);
 double lan;
 double lug;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Googlem> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {
  };

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  void initState() {

    print(widget.lug);

      _markers.add(Marker(
        markerId: MarkerId((widget.lan+widget.lug).toString()),
        position: LatLng(widget.lan,widget.lug),//widget.center,
        infoWindow: InfoWindow(
          title: 'Attendence',
          snippet: 'virash',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

    super.initState();
  }

  void _onAddMarkerButtonPressed() {

  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MAP ATTENDENCE'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lan,widget.lug),
                zoom: 18.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget> [
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
