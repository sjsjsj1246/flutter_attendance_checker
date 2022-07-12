import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool choolCheckDone = false;
  GoogleMapController? mapController;

  static final LatLng companyLatLng = LatLng(37.5233273, 126.921252);
  static final double okDistance = 100;
  static final CameraPosition initialCameraPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );
  static final Circle withinDistanceCircle = Circle(
      circleId: CircleId('withinDistanceCircle'),
      center: companyLatLng,
      fillColor: Colors.blue.withOpacity(0.5),
      radius: okDistance,
      strokeColor: Colors.blue,
      strokeWidth: 1);
  static final Circle notWithinDistanceCircle = Circle(
      circleId: CircleId('notWithinDistanceCircle'),
      center: companyLatLng,
      fillColor: Colors.red.withOpacity(0.5),
      radius: okDistance,
      strokeColor: Colors.red,
      strokeWidth: 1);
  static final Circle checkDoneCircle = Circle(
      circleId: CircleId('checkDoneCircle'),
      center: companyLatLng,
      fillColor: Colors.green.withOpacity(0.5),
      radius: okDistance,
      strokeColor: Colors.green,
      strokeWidth: 1);
  static final Marker marker = Marker(
    markerId: MarkerId('marker'),
    position: companyLatLng,
    icon: BitmapDescriptor.defaultMarker,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppBar(),
        body: FutureBuilder<String>(
            future: checkPermission(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data == "위치 권한이 허가되었습니다") {
                return StreamBuilder<Position>(
                    stream: Geolocator.getPositionStream(),
                    builder: (context, snapshot) {
                      bool isWithinRange = false;

                      if (snapshot.hasData) {
                        final start = snapshot.data!;
                        final end = companyLatLng;

                        final distance = Geolocator.distanceBetween(
                            start.latitude,
                            start.longitude,
                            end.latitude,
                            end.longitude);

                        if (distance < okDistance) {
                          isWithinRange = true;
                        }
                      }

                      return Column(
                        children: [
                          _CustomGoogleMap(
                            circle: choolCheckDone
                                ? checkDoneCircle
                                : isWithinRange
                                    ? withinDistanceCircle
                                    : notWithinDistanceCircle,
                            marker: marker,
                            initialCameraPosition: initialCameraPosition,
                            onMapCreated: onMapCreated,
                          ),
                          _CheckButton(
                              isWithinRange: isWithinRange,
                              onPressed: onChoolCheckPressed,
                              choolCheckDone: choolCheckDone)
                        ],
                      );
                    });
              }

              return Center(
                child: Text(snapshot.data),
              );
            }));
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  onChoolCheckPressed() async {
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("출근하기"),
            content: Text("출근을 하시겠습니까?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("취소"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("출근하기"),
              ),
            ],
          );
        });

    if (result) {
      setState(() {
        choolCheckDone = true;
      });
    }
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return "위치 서비스를 활성화해주세요";
    }

    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();

      if (checkPermission == LocationPermission.denied) {
        return "위치 권한을 허가해주세요";
      }
    }

    if (checkPermission == LocationPermission.deniedForever) {
      return "앱의 위치 권한을 허가해주세요";
    }

    return "위치 권한이 허가되었습니다";
  }

  AppBar renderAppBar() {
    return AppBar(
      title: Text("오늘도 출근",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700)),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
            onPressed: () async {
              final location = await Geolocator.getLastKnownPosition();
              if (mapController == null || location == null) return;
              mapController!.animateCamera(CameraUpdate.newLatLng(
                  LatLng(location.latitude, location.longitude)));
            },
            color: Colors.blue,
            icon: Icon(Icons.my_location))
      ],
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Circle circle;
  final Marker marker;
  final MapCreatedCallback onMapCreated;

  const _CustomGoogleMap(
      {required this.marker,
      required this.circle,
      required this.initialCameraPosition,
      required this.onMapCreated,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialCameraPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: Set.from([circle]),
        markers: Set.from([marker]),
        onMapCreated: (GoogleMapController controller) {
          onMapCreated(controller);
        },
      ),
    );
  }
}

class _CheckButton extends StatelessWidget {
  final bool isWithinRange;
  final VoidCallback onPressed;
  final bool choolCheckDone;

  const _CheckButton(
      {required this.isWithinRange,
      required this.onPressed,
      required this.choolCheckDone,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.timelapse_outlined,
          size: 50.0,
          color: choolCheckDone
              ? Colors.green
              : isWithinRange
                  ? Colors.blue
                  : Colors.red,
        ),
        const SizedBox(height: 20.0),
        if (!choolCheckDone && isWithinRange)
          TextButton(
            child: Text("출근 체크"),
            onPressed: onPressed,
          ),
      ],
    ));
  }
}
