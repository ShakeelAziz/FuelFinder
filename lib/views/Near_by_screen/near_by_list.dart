import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fuel_finder_app/models/place_model.dart';
import 'package:fuel_finder_app/services/gplace_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Place_detail.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin, math;
import 'package:flutter_compass/flutter_compass.dart';

class NearByList extends StatefulWidget {
  NearByList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NearByListState createState() => _NearByListState();
}

class _NearByListState extends State<NearByList> {
  List<Result> list = [];
  List<Result> oldlist = [];
  List<Result> _filteredList = [];
  Position position;
  bool serviceEnabled;
  TextEditingController controller = new TextEditingController();
  String filter = "";
  bool isLoading = true;
  var item;
  List<Geometry> dist = [];
  List<double> distances = [];
  Widget appBarTitle = new Text("Search for Gas Here..",style: TextStyle(color: Colors.black),);
  Icon actionIcon = new Icon(Icons.search,color: Colors.black,);
  double _direction;
  final _biggerFont = const TextStyle(fontSize: 15.0);
  String _currentPlaceId;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _determinePosition().whenComplete(() => getData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if((filter.isNotEmpty)) {
      List<Result> tmpList = [];
      for(int i = 0; i < _filteredList.length; i++) {
        if(_filteredList[i].name.toLowerCase().contains(filter.toLowerCase())) {
          tmpList.add(_filteredList[i]);
        }
      }
      _filteredList = tmpList;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search for gas",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
            ),
          ),
          isLoading? Center(child: CircularProgressIndicator(),):
          Container(
            height: MediaQuery.of(context).size.height-210,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
               physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: list == null ? 0 : _filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return  Card(
                  child: Container(
                    child: ListTile(
                        title: Text(
                          _filteredList[index].name,
                          style: _biggerFont,
                        ),
                        leading: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            radius: 24,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: ( _filteredList[index]
                                  .name
                                  .toLowerCase()
                                  .contains("total"))
                                  ? Image.asset(
                                "images/total.png",
                                height: 50,
                              )
                                  : Image.asset(
                                "images/newfuleicon.png",
                                height: 50,
                              ),
                              radius: 22,
                            )),
                        trailing: Column(
                          children: [
                            (distances != null)
                                ? Text(
                                distances[index].toStringAsFixed(2) + " km")
                                : Text(""),
                            Transform.rotate(
                              angle: ((_direction ?? 0) * (pi / 180) * -1),
                              child: CircleAvatar(
                                  backgroundColor: Colors.black45,
                                  child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        child: Image(
                                          image: AssetImage("images/gps.png"),
                                        ),
                                      ))),
                            )
                          ],
                        ),
                        subtitle: Text( _filteredList[index].vicinity),
                        onTap: () {
                          _currentPlaceId =  _filteredList[index].placeId;
                          // onItemTapped();
                          handleItemTap( _filteredList[index]);
                        }),
                  ),
                );
              },
            ),
          ),
        ],),
      )
    );
  }
  Future<List<Result>> getNearbyPlaces(Position pos) async {
    double lat;
    double long;
    if (pos.longitude != null && pos.latitude != null) {
      setState(() {
        lat = pos.latitude.toDouble();
        long = pos.longitude.toDouble();
      });
      // calculateDistance();
    } else {
      setState(() {
        lat = 1.000000;
        long = 1.00000;
      });
    }

    final String url =
    // "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.6352985,73.0738801&radius=1500&key=AIzaSyCTn4Z3MAP7r08YC5uttzpMY9kNoAWN87c&type=gas_station";
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat.toString()},${long.toString()}&radius=15000&key=AIzaSyCTn4Z3MAP7r08YC5uttzpMY9kNoAWN87c&type=gas_station";

    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();
    var distance;
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data)['results'];

      for (var results in result) {
        oldlist.add(Result.fromJson(results));

        dist.add(Geometry.fromJson(results['geometry']));
      }
      getDistance(distances);


      return oldlist;
    } else {
      print(response.reasonPhrase);
    }
  }

  void getDistance(List<double> distances) {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    double totalDistance = 0;
    for (var i = 0; i < oldlist.length; i++) {
      totalDistance = calculateDistance(position.latitude, position.longitude,
          oldlist[i].geometry.location.lat, oldlist[i].geometry.location.lng);
      distances.add(totalDistance);
    }
    // print(distances.toString()+"Pppppppppppppppppp");
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position pos) {
      setState(() {
        position = pos;
      });
      print(position.longitude.toString());
    });
  }

  getData() {
    getNearbyPlaces(position).whenComplete(() {
      isLoading = false;
      List<Result> tmpList =  [];
      for(int i=0; i < oldlist.length; i++) {
        tmpList.add(oldlist[i]);
      }
      setState(() {
        list = tmpList;
        _filteredList = list;
      });
      controller.addListener(() {
        if(controller.text.isEmpty) {
          setState(() {
            filter = "";
            _filteredList = list;
          });
        } else {
          setState(() {
            filter = controller.text;
          });
        }
      });
    });
  }

  handleItemTap(Result place) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new PlaceDetailPage(place)));
  }
}
