import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_finder_app/models/Prices_model.dart';
import 'package:fuel_finder_app/models/place_model.dart';
import 'package:fuel_finder_app/views/drawer.dart';
import 'package:fuel_finder_app/views/Near_by_screen/near_by.dart';
import 'package:fuel_finder_app/views/Near_by_screen/near_by_maps.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'At_address_screen/at_address_screen.dart';
import 'Near_by_screen/Place_detail.dart';
import 'Near_by_screen/near_by_list.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:math' show cos, sqrt, asin, math;

import 'dummysearch.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _currentAddress;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    //ListPersonPage(),
    NearByList(),
    NearByMaps(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: (_currentAddress!=null)?Text(_currentAddress):Text("Getting Location.."),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: DrawerSide(),
      bottomNavigationBar: _bottomnavigationBar(),
    );
  }

  _bottomnavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.language), label: "Map"),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.black,
      iconSize: 25,
      onTap: _onItemTapped,
      elevation: 5,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position position;
  bool serviceEnabled;
  double distanceinMeters;
  String _currentAddress;
  String countrycode;
  String price, diesel, currency;
  List<GppElement> item = [];
  List<Geometry> dist = [];
  List<double> distances = [];
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    super.initState();
    _determinePosition();
  }
  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;
    final Height = MediaQuery.of(context).size.height;
    return Stack(
      children:[
        SingleChildScrollView(
           physics: BouncingScrollPhysics(),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 5),
              child: Container(
                height: 50,
                width: Width,
                child: TextField(
                  readOnly: true,
                  onTap: (){Navigator.push(context, MaterialPageRoute(
                      builder: (co) => AtAddressScreen()));},
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        labelText: "Search here...",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.black12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
             decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(15.0)),
             height: 50,
             width: Width,
             child:(_currentAddress !=null )
                 ? ListTile(title: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     Text("Prices this Week for:"),
                     Text(_currentAddress,style: TextStyle(fontSize: 18,color: Colors.red),),
                   ],
                 ),
                trailing:(price!=null && diesel !=null) ?Column(
                  children: [
                    Text("Gasoline: ${price} - ${currency}"),
                    Text("Diesel: ${diesel} - ${currency}"),
                  ],
                ):Text("Getting Prices.."),
             )
                 : Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text("Getting Location.."),
                 )
         ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Container(
                height: 250,
                width: Width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                        image: AssetImage("images/total_pic.png"),
                        fit: BoxFit.cover)),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Fill Up at Total and get \ndouble points this Week..!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                //decoration: BoxDecoration(color: Colors.red),
                height: 80,
                child: FutureBuilder<List<Result>>(
                    future: getNearbyPlaces(position),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 160,
                              childAspectRatio: 1.5 / 1,
                              crossAxisSpacing: 5),
                          // padding: EdgeInsets.all(10.0),
                          itemCount: 6,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (co) => PlaceDetailPage(snapshot.data[index])));
                              },
                              child: Card(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                    Container(
                                      height: 40,
                                      child: (snapshot.data[index].name
                                              .toLowerCase()
                                              .contains("total"))
                                          ? Image.asset(
                                              "images/total.png",
                                              height: 50,
                                            )
                                          :Image.asset(
                                        "images/newfuleicon.png",
                                        height: 50,
                                      )
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                   distances!=null? Text(distances[index].toStringAsFixed(2) + " km"):Text("-km")
                                  ])),
                            );
                          },
                        );
                      }
                    })),
            Container(
              //decoration: BoxDecoration(color: Colors.black12),
              height: 200,
              child: GridView.count(
                crossAxisCount: 2,
                //childAspectRatio: 1.5 / 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                padding: EdgeInsets.all(8.0),
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                            image: AssetImage("images/food.jpg"),
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.centerLeft),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                            image: AssetImage("images/fuel.jpg"),
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ]),
        ),
        if (_isBannerAdReady)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
          ),
    ]);
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
    List<Result> list = [];
    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      var data = await response.stream.bytesToString();
      var result = json.decode(data)['results'];
      for (var results in result) {
        list.add(Result.fromJson(results));
        dist.add(Geometry.fromJson(results['geometry']));
        getDistance(distances);
      }
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
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((Position pos) {
      setState(() {
        position = pos;
        _getAddressfromLatlang(position);
      });
      print(position.longitude.toString());
    });
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
    for (var i = 0; i < dist.length - 1; i++) {
      totalDistance = calculateDistance(position.latitude, position.longitude,
          dist[i].location.lat, dist[i].location.lng);
      distances.add(totalDistance);
    }
    // print(distances);
  }
  Future<void> _getAddressfromLatlang(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    _currentAddress = '${place.country}';
    countrycode = '${place.isoCountryCode}';
    _getData(countrycode);
    _getDiesel(countrycode);
  }

  Future<List<GppElement>> _getData(String code) async {
    final Xml2Json xml2Json = Xml2Json();
    var headers = {

      'Cookie': '20211127122222=1; 20211127122551=1; PHPSESSID=2d5c7fc3943ef7b7ed78f1ab0f7e1d9d; my_session_id=2d5c7fc3943ef7b7ed78f1ab0f7e1d9d'
    };
    var request = http.Request('GET', Uri.parse('https://www.globalpetrolprices.com/api_gpp.php?cnt=$code&ind=gp&prd=latest&uid=2804&uidc=98cf0bc91cb47d11f4bd82c9af744ea2'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
     var data = await response.stream.bytesToString();
      try {
        xml2Json.parse(data);
        var jsondata = xml2Json.toParkerWithAttrs();
        var lists = json.decode(jsondata);
        var list1 = lists['gpp:data']["gpp:element"];
        // print("2222222222222222" + list1.toString());

        // print(list1['gpp:gasoline']);


          setState((){
            price = list1["gpp:gasoline"].toString();
            currency = list1["gpp:currency"].toString();
          });
          // print(price+"ppppppppppppppppppp");



      } on Exception catch (e) {
        // TODO
      }
    } else {
      print(response.reasonPhrase);
    }
  }
  Future<List<GppElement>> _getDiesel(String code) async {
    final Xml2Json xml2Json = Xml2Json();
    var headers = {

      'Cookie': '20211127122222=1; 20211127122551=1; PHPSESSID=2d5c7fc3943ef7b7ed78f1ab0f7e1d9d; my_session_id=2d5c7fc3943ef7b7ed78f1ab0f7e1d9d'
    };
    var request = http.Request('GET', Uri.parse('https://www.globalpetrolprices.com/api_gpp.php?cnt=$code&ind=dp&prd=latest&uid=2804&uidc=98cf0bc91cb47d11f4bd82c9af744ea2'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
     var data = await response.stream.bytesToString();
      try {
        xml2Json.parse(data);
        var jsondata = xml2Json.toParkerWithAttrs();
        var lists = json.decode(jsondata);
        var list1 = lists['gpp:data']["gpp:element"];
        // print("2222222222222222" + list1.toString());

        // print(list1['gpp:diesel']);


          setState((){
            diesel = list1["gpp:diesel"].toString();
          });
          // print(diesel+"ppppppppppppppppppp");



      } on Exception catch (e) {
        // TODO
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}