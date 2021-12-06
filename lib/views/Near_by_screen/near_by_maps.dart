import 'dart:convert';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fuel_finder_app/models/place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class NearByMaps extends StatefulWidget {
  const NearByMaps({Key key}) : super(key: key);

  @override
  _NearByMapsState createState() => _NearByMapsState();
}

class _NearByMapsState extends State<NearByMaps> {
  Position position;
  final LatLng _initialCameraPosition = const LatLng(1,1);
  GoogleMapController _controller;
  final Location _location = Location();
  bool serviceEnabled;
  List<Result> _places;
  double lat;
  double long;
  String name;
  double ratings;
  List<Marker> markers = <Marker>[];

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 14),
        ),
      );
    });
  }

  void initState() {
    serviceEnabled = true;
    super.initState();
    _determinePosition();


    // print("count: "+_places.length.toString());
  }

  MapType _mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition:
                CameraPosition(target: _initialCameraPosition, zoom: 14),
            scrollGesturesEnabled: true,
            myLocationButtonEnabled: false,
            mapType: _mapType,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
            mapToolbarEnabled: true,
            tiltGesturesEnabled: true,
            markers: Set<Marker>.of(markers),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () => _onMaptypePressed(),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.map,
                size: 36.0,
              ),
            )),
      ),
    );
  }

  void _onMaptypePressed() {
    setState(() {
      _mapType =
          _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  getNearbyPlaces(Position pos) async {
    double lat;
    double long;
    if (pos.longitude != null && pos.latitude != null) {
      setState(() {
        lat = pos.latitude.toDouble();
        long = pos.longitude.toDouble();
      });
    } else {
      setState(() {
        lat = 1.000000;
        long = 1.00000;
      });
    }
    setState(() {
      markers.clear();
    });
    final String url =
        // "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.6352985,73.0738801&radius=1500&key=AIzaSyCTn4Z3MAP7r08YC5uttzpMY9kNoAWN87c&type=gas_station";
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat.toString()},${long.toString()}&radius=5000&key=AIzaSyCTn4Z3MAP7r08YC5uttzpMY9kNoAWN87c&type=gas_station";

    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();
    List<Result> list = [];
    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      var data = await response.stream.bytesToString();
      var result = json.decode(data)['results'];
      for (var results in result) {
        list.add(Result.fromJson(results));
      }
      _handleResponseforMarkers(list);
      return list;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location Services are Disabled!");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Permissions are Denied!");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location Permissions are permanently denied, we cannot Request permission.");
    }
    return await Geolocator.getCurrentPosition().then((Position pos) {
      setState(() {
        position = pos;
      });
      if (_places == null) {
        getNearbyPlaces(position).then((data) {
          this.setState(() {
            _places = data;
          });
        });
      }
      print(position.longitude.toString());
    });
  }

  void _handleResponseforMarkers(List<Result> data) {
    BitmapDescriptor customIcon;
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'images/newfuleicon.png').then((d) {
          setState(() {
            customIcon = d;

          });
    });
    setState(() {
      for (int i = 0; i < data.length; i++) {
        markers.add(Marker(
          markerId: MarkerId(data[i].placeId),
          position: LatLng(
              data[i].geometry.location.lat, data[i].geometry.location.lng),
          infoWindow: InfoWindow(title: data[i].name,snippet: data[i].vicinity),
          icon:customIcon,
          onTap: (){}
        ));
      }
    });
  }
}
