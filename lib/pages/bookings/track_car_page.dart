import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rentalku/commons/colors.dart';
import 'package:rentalku/commons/styles.dart';

class TrackCarPage extends StatefulWidget {
  const TrackCarPage({Key? key}) : super(key: key);

  @override
  _TrackCarPageState createState() => _TrackCarPageState();
}

class _TrackCarPageState extends State<TrackCarPage> {
  Marker? _marker;
  late Timer timer;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _position = CameraPosition(
    target: LatLng(-7.9680376, 112.5937865),
    zoom: 15,
  );
  double _latitude = -7.9680376;
  double _longitude = 112.5937865;
  String address = "Searching Location....";
  String plateNumber = "X 1234 XX";
  bool follow = true;

  @override
  void initState() {
    setupMarker();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void setupMarker() async {
    _marker = Marker(
      markerId: MarkerId("car"),
      position: LatLng(-7.9680376, 112.5937865),
      infoWindow: InfoWindow(title: "Mobil"),
      icon: await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(12, 12)),
        "assets/images/car_icon.png",
      ),
    );

    setState(() {});
  }

  Future<void> toCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_latitude, _longitude),
          zoom: await controller.getZoomLevel(),
        ),
      ),
    );
  }

  Future<void> updateLocation() async {
    final GoogleMapController controller = await _controller.future;

    // Simulate change location
    Map<String, double> coordinate = await Future.delayed(
      Duration(milliseconds: 500),
      () => {
        "latitude": _latitude + 0.00005,
        "longitude": _longitude + 0.00005,
      },
    );
    _latitude = coordinate['latitude']!;
    _longitude = coordinate['longitude']!;

    await toAddress(_latitude, _longitude);

    if (_marker != null) {
      setState(() {
        _marker =
            _marker!.copyWith(positionParam: LatLng(_latitude, _longitude));
      });
    }

    if (follow) {
      await toCurrentLocation();
    }
  }

  Future<void> toAddress(double latitude, double longitude) async {
    _latitude = latitude;
    _longitude = longitude;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      setState(() {
        address = [
          place.street,
          place.postalCode,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
        ].join(", ");
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    timer = Timer.periodic(Duration(seconds: 1), (timer) => updateLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Listener(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _position,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.from([_marker]),
            ),
            onPointerMove: (_) {
              setState(() {
                follow = false;
              });
            },
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Row(
                        children: [
                          Text(
                            "Detail Objek",
                            style: AppStyle.regular2Text,
                          ),
                          Spacer(),
                          Icon(Icons.history, color: Colors.black, size: 16),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (!follow)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: FloatingActionButton(
                        onPressed: () {
                          toCurrentLocation();
                          setState(() {
                            follow = true;
                          });
                        },
                        child: Icon(Icons.my_location),
                        backgroundColor: AppColor.green,
                        mini: true,
                      ),
                    ),
                  ),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          plateNumber,
                          style: AppStyle.regular1Text.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          address,
                          style: AppStyle.regular2Text,
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
    );
  }
}
