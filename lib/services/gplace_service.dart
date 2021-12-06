import 'package:http/http.dart' as http;
import '../models/place_model.dart';
import 'dart:async';
import 'dart:convert';

class LocationService {
  static final _locationService = new LocationService();

  static LocationService get() {
    return _locationService;
  }

  final String detailUrl =
      "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyCTn4Z3MAP7r08YC5uttzpMY9kNoAWN87c&placeid=";

  Future<List<Result>> getNearbyPlaces() async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.6352985,73.0738801&radius=1500&key=AIzaSyCTn4Z3MAP7r08YC5uttzpMY9kNoAWN87c&type=gas_station";

    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();
    List<Result> list = [];
    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      var data = await response.stream.bytesToString();
    var result = json.decode(data)['results'];
      for(var results in result){
        list.add(Result.fromJson(results));
      }
      return list;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getPlace(String place_id) async {
    var response = await http
        .get(Uri.parse(detailUrl + place_id), headers: {"Accept": "application/json"});
    var result = json.decode(response.body)["results"];
    return result;
  }

}
