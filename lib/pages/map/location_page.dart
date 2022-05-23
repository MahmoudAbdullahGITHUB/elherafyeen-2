import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  double latitude;
  double longitude;

  LocationPage(this.longitude, this.latitude);

  @override
  _ShowMapState createState() => _ShowMapState(this.longitude, this.latitude);
}

class _ShowMapState extends State<LocationPage> {
  double latitude;
  double longitude;

  _ShowMapState(this.longitude, this.latitude);

  Marker myMark;

  void _updatePosition(LatLng _position) {
    setState(() {
      myMark = myMark.copyWith(
          positionParam: LatLng(_position.latitude, _position.longitude));
    });
  }

  @override
  initState() {
    var marker = BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)),
            'assets/images/car-icon.png')
        .then((d) {
      // customIcon = d;
    });
    myMark = Marker(
      markerId: MarkerId("myMarkId"),
      draggable: false,
      position: LatLng(latitude, longitude),
      onTap: () {},
    );
    super.initState();
  }

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: HColors.colorPrimaryDark,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 17.0,
        ),
        onTap: _updatePosition,
        markers: Set.from([
          myMark,
        ]),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
            {
              "latitude": myMark.position.latitude,
              "longitude": myMark.position.longitude,
            },
          );
        },
        child: Icon(
          Icons.check,
          size: 40,
          color: Colors.white,
        ),
        backgroundColor: HColors.colorSecondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
