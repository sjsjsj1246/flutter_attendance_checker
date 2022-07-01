import 'package:flutter/material.dart';
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
        body: Column(
          children: [
            _CustomGoogleMap(
              initialCameraPosition: initialCameraPosition,
            ),
            _CheckButton()
          ],
        ));
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
