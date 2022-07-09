import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final LatLng companyLatLng = LatLng(37.5233273, 126.921252);
  static final CameraPosition initialCameraPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppBar(),
        body: FutureBuilder(
            future: checkPermission(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data == "위치 권한이 허가되었습니다") {
                return Column(
                  children: [
                    _CustomGoogleMap(
                      initialCameraPosition: initialCameraPosition,
                    ),
                    _CheckButton()
                  ],
                );
              }

              return Center(
                child: Text(snapshot.data),
              );
            }));
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
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialCameraPosition;

  const _CustomGoogleMap({required this.initialCameraPosition, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialCameraPosition,
      ),
    );
  }
}

class _CheckButton extends StatelessWidget {
  const _CheckButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text("출첵"),
    );
  }
}
