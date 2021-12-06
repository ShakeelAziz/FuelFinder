import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_finder_app/views/drawer.dart';
import 'package:fuel_finder_app/views/Near_by_screen/near_by_list.dart';
import 'package:fuel_finder_app/views/Near_by_screen/near_by_maps.dart';
import 'package:fuel_finder_app/widgets/commonwidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class NearByScreen extends StatefulWidget {
  Position position;

  NearByScreen({Key key, this.position}) : super(key: key);

  @override
  _NearByScreenState createState() => _NearByScreenState(position);
}

class _NearByScreenState extends State<NearByScreen>
    with SingleTickerProviderStateMixin {
  Position _currentPosition;
  String _currentAddress;
  String position;
  bool serviceEnabled;
  _NearByScreenState(Position _currentPosition) {
    this._currentPosition = _currentPosition;
  }

  List<Choice> choices = const <Choice>[
    Choice(title: 'Share', icon: Icons.arrow_right),
    Choice(title: 'Report missing entry', icon: Icons.exit_to_app),
  ];

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
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
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressfromLatlang(_currentPosition);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
  }

  Future<void> _getAddressfromLatlang(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: DrawerSide(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            unselectedLabelColor: Colors.black,
            isScrollable: false,
            labelColor: Colors.red,
            tabs: [
              Tab(
                text: "LIST",
              ),
              Tab(
                text: "MAP",
              ),
            ],
            indicatorColor: Colors.red,
            indicatorWeight: 2,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(
                text: "Nearby",
                fontSize: 45.sp,
                color: Colors.black,
              ),
              buildText(
                text: (_currentAddress != null)
                    ? _currentAddress.toString().trim()
                    : "Getting Location...",
                fontSize: 35.sp,
                color: Colors.grey,
              ),
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              color: Colors.white,
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            choice.title,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Icon(
                            choice.icon,
                            color: Colors.black,
                          ),
                        ],
                      ));
                }).toList();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            NearByList( ),
            NearByMaps(),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
