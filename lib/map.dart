import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  MapScreen(
      {super.key, this.title = "Map", required this.lat, required this.long, required this.name});
  final double lat;
  final double long;
  final String name;
  final String title;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    askForPermission();
  }

  void askForPermission() async {
    await Permission.location.request();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            height: size.height * 0.85,
            child: GoogleMap(
              myLocationEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.long),
                zoom: 15.0,
              ),
              onMapCreated: _onMapCreated,
              markers: {
                Marker(
                  markerId: MarkerId(widget.name),
                  position: LatLng(widget.lat, widget.long),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
