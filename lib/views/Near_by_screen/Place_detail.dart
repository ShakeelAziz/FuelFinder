import 'package:flutter/material.dart';
import 'package:fuel_finder_app/models/place_model.dart';
import 'package:fuel_finder_app/services/gplace_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PlaceDetailPage extends StatefulWidget {
  Result place;

  PlaceDetailPage(this.place);

  @override
  State createState() => new _PlaceDetailState(place);
}

class _PlaceDetailState extends State<PlaceDetailPage> {
  Result place;

  _PlaceDetailState(Result place) {
    this.place = place;
  }

  LocationData _currentPosition;
  GoogleMapController mapController;
  Marker marker;
  bool _isMarkerset = false;
  Location location = Location();
  MapType _currentMapType = MapType.normal;
  List<Marker> _markers = [];
  GoogleMapController _controller;
  static LatLng _initialcameraposition = LatLng(24.8607, 67.0011);
  LatLng _lastmapposition = _initialcameraposition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoc();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                  place.geometry.location.lat, place.geometry.location.lng),
              zoom: 17),
        ),
      );
    });
    marker = Marker(
      markerId: MarkerId('0'),
      infoWindow: InfoWindow(
          title: place.name, snippet: "ratings:" + place.rating.toString()),
      position:
          LatLng(place.geometry.location.lat, place.geometry.location.lng),
      icon: BitmapDescriptor.defaultMarker,
    );
    setState(() {
      _markers.add(marker);
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconTheme.of(context),
        title: Text(
          "Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 24,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: (place.name
                      .toLowerCase()
                      .contains("total"))
                      ? Image.asset(
                    "images/total.png",
                    height: 50,
                  )
                      :Image.asset(
                    "images/newfuleicon.png",
                    height: 50,
                  ),
                  radius: 22,
                )),
            title: Text(place.name),
            subtitle: Text(place.vicinity),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition:
                    (place.geometry.location.lat != null &&
                            place.geometry.location.lng != null)
                        ? CameraPosition(
                            target: LatLng(place.geometry.location.lat,
                                place.geometry.location.lng),
                            zoom: 15)
                        : CameraPosition(
                            target: _initialcameraposition, zoom: 17),
                mapType: _currentMapType,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                markers: _markers.toSet(),
                // onCameraMove: _onCameraMove,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
      });
    });
  }
}
